class SourceBiasLevel < ActiveRecord::Base
  belongs_to :source
  belongs_to :bias
end
