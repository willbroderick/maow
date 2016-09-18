class TopicsController < ApplicationController
  def show
    @topic = Topic.find(params.require(:id))
    @industry = @topic.industry
    @bias = Bias.take
  end
end
