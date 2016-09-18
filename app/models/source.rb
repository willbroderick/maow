class Source < ActiveRecord::Base
  belongs_to :industry
  has_many :articles
  has_many :source_bias_levels

  def fetch
    total = 0
    if last_fetched.nil? || last_fetched < DateTime.current - 30.minutes
      feed = Feedjira::Feed.fetch_and_parse rss_url
      feed.entries.each do |entry|
        uid = Article.uid_from_entry(entry)
        if !articles.where(uid: uid).exists?
          total += 1 if articles.create_from_entry(entry)
        end
      end
    end
    return total
  end

  def rebuild_entities
    total = 0
    articles.each do |article|
      total += article.rebuild_entity_relations
    end
    return total
  end

  def uid_from_entry(entry)
    entry.entry_id
  end
end
