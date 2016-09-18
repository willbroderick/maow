class Bias < ActiveRecord::Base
  belongs_to :industry
  has_many :source_bias_levels
end
