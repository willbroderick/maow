class EntitiesController < ApplicationController
  def reassess_all_for_industry
    @industry = Industry.find(params.require(:id))
    @industry.reassess_entity_importances
  end
end