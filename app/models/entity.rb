class Entity < ActiveRecord::Base
  belongs_to :industry
  has_many :article_entities
  has_many :articles, through: :article_entities
end
