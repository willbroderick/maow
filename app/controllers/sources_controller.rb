class SourcesController < ApplicationController
  def fetch_all_for_industry
    @industry = Industry.find(params.require(:id))
    @total = 0
    @industry.sources.where(enabled: true).each do |source|
      @total = @total + source.fetch
    end
  end

  def rebuild_all_for_industry
    @industry = Industry.find(params.require(:id))
    @total = 0
    @industry.sources.where(enabled: true).each do |source|
      @total = @total + source.rebuild_entities
    end
  end
end