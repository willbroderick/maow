class TopicRule < ActiveRecord::Base
  belongs_to :topic

  enum logic: [
    :has_entity,
    :does_not_have_entity,
    :published_after,
    :published_before
    ]

  def add_to_article_query(query)
    case logic.to_sym
    when :has_entity
      query.where('articles.id IN (SELECT article_id FROM article_entities WHERE entity_id = ?)', value_integer)
    when :does_not_have_entity
      query.where('articles.id NOT IN (SELECT article_id FROM article_entities WHERE entity_id = ?)', value_integer)
    when :published_before
      query.where('published_at < ?', value_datetime)
    when :published_after
      query.where('published_at > ?', value_datetime)
    else
      query
    end
  end

  def summary
    case logic.to_sym
    when :has_entity
      "Contains #{entity_text}"
    when :does_not_have_entity
      "Does not contain #{entity_text}"
    when :published_before
      "Before #{value_datetime}"
    when :published_after
      "After #{value_datetime}"
    end
  end

  private

  def entity_text
    Entity.find(value_integer).entity
  end
end
