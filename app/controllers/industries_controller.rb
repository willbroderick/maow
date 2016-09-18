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
end
