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

  def operator_summary
    case logic.to_sym
    when :has_entity
      'Contains'
    when :does_not_have_entity
      'Does not contain'
    when :published_before
      'Before'
    when :published_after
      'After'
    end
  end

  def operand_summary
    case logic.to_sym
    when :has_entity
      entity_text
    when :does_not_have_entity
      entity_text
    when :published_before
      value_datetime.to_s
    when :published_after
      value_datetime.to_s
    end
  end

  private

  def entity_text
    Entity.find(value_integer).entity
  end
end
