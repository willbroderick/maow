class Article < ActiveRecord::Base
  belongs_to :source
  has_many :article_entities
  has_many :entities, through: :article_entities

  def self.create_from_entry(entry, build_entities = true)
    article = create do |article|
      article.uid = Article.uid_from_entry(entry)
      article.title = entry.title
      article.summary = entry.summary
      article.published_at = entry.published
      article.url = entry.url
      article.raw = ''
      article.raw << entry.title.downcase << ' ' << entry.summary.downcase
      article.raw << ' ' << entry.categories.join(', ').downcase
    end
    article.build_entity_relations
    return article
  end

  def self.uid_from_entry(entry)
    entry.entry_id
  end

  def build_entity_relations
    total = 0
    source.industry.entities.each do |entity|
      if raw.include?(entity.entity)
        self.entities << entity
        total += 1
      end
    end
    return total
  end

  def rebuild_entity_relations
    article_entities.destroy_all
    build_entity_relations
  end
end
