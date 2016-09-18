class Topic < ActiveRecord::Base
  belongs_to :industry
  has_many :topic_rules

  def articles
    # find all matching articles
    query = industry.articles
    topic_rules.each do |rule|
      query = rule.add_to_article_query(query)
    end
    query
  end
end
