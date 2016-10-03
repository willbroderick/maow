class Industry < ActiveRecord::Base
  has_many :sources, dependent: :destroy
  has_many :biases, dependent: :destroy
  has_many :topics, dependent: :destroy
  has_many :entities, dependent: :destroy
  has_many :articles, through: :sources
end
