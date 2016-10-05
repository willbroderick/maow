class Industry < ActiveRecord::Base
  SUPERFLUITY_RATIO = 0.4

  has_many :sources, dependent: :destroy
  has_many :biases, dependent: :destroy
  has_many :topics, dependent: :destroy
  has_many :entities, dependent: :destroy
  has_many :articles, through: :sources

  def reassess_entity_importances
    # items with importance 0 are cool
    # items with importance 1 are new
    # items with importance greater than 1 have been customised

    # items in 40% of articles are not helpful
    entities_to_delete = entities.select('id, entity').where(%{
        COUNT(
          SELECT id
          FROM article_entities
          WHERE article_entities.entity_id = entities.id
        ) > ? * COUNT(
          SELECT id
          FROM articles
          LEFT JOIN sources ON articles.source_id = sources.id
          WHERE sources.industry_id = ?
        )
      }, SUPERFLUITY_RATIO, self.id)
    abort entities_to_delete.inspect
    #ArticleEntity.where('entity_id IN ?', entities_to_delete).delete_all
  end
end
