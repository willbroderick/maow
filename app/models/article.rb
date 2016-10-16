class Article < ActiveRecord::Base
  belongs_to :source
  has_many :article_entities, dependent: :delete_all
  has_many :entities, through: :article_entities
  has_many :article_graph_vertices, foreign_key: :article_1_id, dependent: :delete_all
  has_many :similar_articles, through: :article_graph_vertices, source: :article_2

  def self.create_from_entry(entry, build_entities = true)
    article = create do |article|
      article.uid = Article.uid_from_entry(entry)
      article.title = entry.title
      article.summary = entry.summary
      article.published_at = entry.published
      article.url = entry.url
      # 'raw' is the raw content we used to build our associations to this article
      article.raw = ''
      article.raw << entry.title.downcase << ' ' << entry.summary.downcase
      article.raw << ' ' << entry.categories.join(', ').downcase
      # remove any html tags
      article.raw.gsub!(/<[^>]*>/, ' ')
      # remove common garbage
      article.raw.gsub!('&nbsp;', ' ')
      # remove consecutive spaces
      article.raw.gsub!(/[\ ]{2,}/, ' ')
    end
    article.build_entity_relations
    return article
  end

  def self.uid_from_entry(entry)
    entry.entry_id
  end

  def build_entity_relations
    total = 0

    # words to check for
    terms_remaining = ' ' + raw.dup.gsub(/[\.\,\:\;]/, ' ') + ' '

    ass_ids = []
    # compound words (e.g. full names) need finding in a first-pass
    source.industry.entities.where(is_compound: true).each do |entity|
      spaced_entity = ' ' + entity.entity + ' '
      if raw.include?(spaced_entity)
        # only create the relation if it serves a purpose
        if entity.importance > 0
          ass_ids.push(entity.id)
        end
        # gobble this up
        terms_remaining.gsub(spaced_entity, ' ')
      end
    end

    # check remaining terms - allow hyphenation and underscores
    terms_remaining = terms_remaining.gsub(/[^\w\_\-\ ]/, '').split(' ').uniq

    # fetch common terms in one query
    common_entities = source.industry.entities.
      where(is_compound: false).
      where(importance: 0).to_a # would be good to cache across calls

    terms_to_add = Set.new
    terms_remaining.each do |term|
      # check against common terms first
      entity = common_entities.detect{ |e| e.entity == term }
      # no? then hit the DB
      if entity.nil?
        entity = source.industry.entities.
          where(is_compound: false).
          where(entity: term).take
      end
      if entity
        # match found
        ass_ids.push(entity.id) if entity.importance > 0
      else
        # new
        terms_to_add.add(term)
      end
    end

    # any new entities to create?
    terms_to_add.each do |term|
      new_entity = source.industry.entities.create(
        entity: term,
        importance: 1
        )
      ass_ids.push(new_entity.id) if !new_entity.new_record?
    end if terms_to_add.length > 0 # don't bother transactin' if nowt to do

    sql = 'DELETE FROM article_entities WHERE article_id=' << self.id.to_s << ';'
    ActiveRecord::Base.connection.execute(sql)
    sql = 'INSERT INTO article_entities (article_id, entity_id) VALUES '
    ass_ids.each do |ass_id|
      sql << '(' << self.id.to_s << ',' << ass_id.to_s << '),'
    end
    sql.chomp!(',')
    sql << ';'
    ActiveRecord::Base.connection.execute(sql)
    ActiveRecord::Base.connection.query_cache.clear

    return ass_ids.length
  end

  def rebuild_entity_relations
    article_entities.delete_all
    build_entity_relations
  end

  def rebuild_vertices(source_ids = nil)
    source_ids ||= source.industry.sources.pluck(:id)

    # clear existing vertices
    article_graph_vertices.delete_all
    vertex_count = 0

    # with each other article (in this industry), find words in common
    if true
      # one query to return all intersecting ids & weight
      sql = %{
        SELECT article_id, SUM(importance) AS weight
        FROM article_entities AS art_ent
          LEFT OUTER JOIN entities ON entities.id = art_ent.entity_id
        WHERE art_ent.entity_id IN
          (
              SELECT t1.entity_id FROM article_entities AS t1
              WHERE t1.article_id = #{self.id} AND importance > 0
            INTERSECT
              SELECT t2.entity_id FROM article_entities AS t2
              WHERE t2.article_id = art_ent.article_id
                AND importance > 0
                AND t2.article_id <> #{self.id}
          )
        GROUP BY art_ent.article_id
        HAVING SUM(importance) > 15;
      }
      result = ActiveRecord::Base.connection.execute(sql)
      # create each vertex
      sql = ''
      result.each do |row|
        sql << 'INSERT INTO article_graph_vertices (article_1_id, article_2_id, weight) '
        sql << "VALUES (#{self.id}, #{row['article_id']}, #{row['weight']});"
        vertex_count += 1
      end
      ActiveRecord::Base.connection.execute(sql)
    else
      # works, but slow as balls
      sql = ''
      articles = Article.where('source_id IN (?)', source_ids).each do |a|
        importances = Entity.where(%{
          id IN (
            SELECT entity_id FROM article_entities
            WHERE article_id = ?
          ) AND id IN (
            SELECT entity_id FROM article_entities
            WHERE article_id = ?
          ) AND importance > 0
          }, self.id, a.id).pluck(:importance)
        sum = importances.sum
        if sum > 15
          sql << 'INSERT INTO article_graph_vertices (article_1_id, article_2_id, weight)'
          sql << " VALUES (#{self.id}, #{a.id}, #{sum});"
          vertex_count += 1
        end
      end
      ActiveRecord::Base.connection.execute(sql)
    end

    return vertex_count
  end
end
