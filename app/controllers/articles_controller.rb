class ArticlesController < ApplicationController
  def show
    @article = Article.includes(:source).find(params.require(:id))
    @topic = Topic.find(params.require(:topic_id))
    @industry = @topic.industry
  end
end
