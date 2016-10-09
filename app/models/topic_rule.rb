class TopicRule < ActiveRecord::Base
  belongs_to :topic

  enum logic: {
    has_entity_or: 0,
    has_entity_and: 1,
    does_not_have_entity: 2,
    published_after: 3,
    published_before: 4
    }

  def to_sql
    sql_arr = if has_entity_and? || has_entity_or?
      ['articles.id IN (SELECT article_id FROM article_entities WHERE entity_id = ?)', value_integer]
    elsif does_not_have_entity?
      ['articles.id NOT IN (SELECT article_id FROM article_entities WHERE entity_id = ?)', value_integer]
    elsif published_before?
      ['published_at < ?', value_datetime]
    elsif published_after?
      ['published_at > ?', value_datetime]
    else
      raise 'unknown entity type'
    end
    ActiveRecord::Base.send(:sanitize_sql_array, sql_arr)
  end

  def operator_summary
    if has_entity_and? || has_entity_or?
      'Contains'
    elsif does_not_have_entity?
      'Does not contain'
    elsif published_before?
      'Before'
    elsif published_after?
      'After'
    end
  end

  def operand_summary
    if has_entity_and? || has_entity_or?
      entity_text
    elsif does_not_have_entity?
      entity_text
    elsif published_before?
      value_datetime.to_s
    elsif published_after?
      value_datetime.to_s
    end
  end

  private

  def entity_text
    Entity.find(value_integer).entity
  end
end
