class Industry < ActiveRecord::Base
  has_many :sources
  has_many :biases
  has_many :topics
  has_many :entities
  has_many :articles, through: :sources
end
