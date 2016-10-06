class Industry < ActiveRecord::Base
  SUPERFLUITY_RATIO = 0.4 # e.g. 0.2 = more than 20% of articles contain entity

  has_many :sources, dependent: :destroy
  has_many :biases, dependent: :destroy
  has_many :topics, dependent: :destroy
  has_many :entities, dependent: :destroy
  has_many :articles, through: :sources

  def reassess_entity_importances
    # items with importance 0 are cool
    # items with importance 1 are new
    # items with importance greater than 1 have been customised

    # items in a large percentage of articles are not helpful
    sql = %{
      SELECT id
      FROM entities
      WHERE entities.industry_id = ?
      AND importance > 0
      AND (
          SELECT COUNT(article_entities.id)
          FROM article_entities
          WHERE article_entities.entity_id = entities.id
        ) > ?
    }
    #abort (articles.count * SUPERFLUITY_RATIO).to_s
    sql = ActiveRecord::Base.send(:sanitize_sql_array, [
      sql,
      self.id, # industry id
      (articles.count * SUPERFLUITY_RATIO).to_i # threshold for unimportance
      ])
    result = ActiveRecord::Base.connection.execute(sql)

    # set these ids importance to 0, and fire callback to clear associations
    entity_ids_to_process = result.map{|r| r['id'] }
    Entity.where(id: entity_ids_to_process).all.each do |entity|
      entity.update(importance: 0) # triggers useful callback
    end
  end
end
