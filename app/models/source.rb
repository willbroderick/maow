class Source < ActiveRecord::Base
  belongs_to :industry
  has_many :articles, dependent: :destroy
  has_many :source_bias_levels, dependent: :destroy

  def fetch
    total = 0
    if last_fetched.nil? || last_fetched < DateTime.current - 30.minutes
      update_columns(last_fetched: DateTime.current)
      # fetch feed
      feed = Feedjira::Feed.fetch_and_parse rss_url
      # ensure we will not exceed capacity limits
      max_articles = Rails.application.config.max_articles_per_source
      min_space_required = max_articles - feed.entries.size
      if articles.count > min_space_required
        number_to_destroy = articles.count - min_space_required
        articles.order('created_at').limit(number_to_destroy).destroy_all
      end
      # build new entries
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
