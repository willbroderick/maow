class TopicsController < ApplicationController
  def show
    @topic = Topic.find(params.require(:id))
    @rules_grouped = @topic.topic_rules.all.group_by{|r| r.has_entity_or? }
    @industry = @topic.industry
    @bias = Bias.take
  end
end
