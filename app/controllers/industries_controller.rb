class IndustriesController < ApplicationController
  def default
    @industry = Industry.take
    @bias = Bias.take
    raise 'System must contain an industry' if @industry.nil?
    render 'landing'
  end

  def landing
    @industry = Industry.find(params.require(:id))
    @bias = Bias.take
  end

  def rebuild_entities_for_industry
    @industry = Industry.find(params.require(:id))
    @total = 0
    @industry.sources.where(enabled: true).each do |source|
      @total = @total + source.rebuild_entities
    end
  end

  def reassess_entities_for_industry
    @industry = Industry.find(params.require(:id))
    @industry.reassess_entity_importances
  end
end
