# importance = 0 are irrelevent and unused
# importance = 1 are new
# importance > 1 have been recognised as important
class Entity < ActiveRecord::Base
  belongs_to :industry
  has_many :article_entities, dependent: :delete_all
  has_many :articles, through: :article_entities

  before_save :set_is_compound
  after_save :detach_if_unimportant

  validates :entity, length: { minimum: 2 }
  validates :entity, length: { maximum: 30 }

  def set_is_compound
    self.is_compound = self.entity.include?(' ')
    return true # do not abort save!
  end

  def detach_if_unimportant
    article_entities.delete_all if importance == 0
  end
end
