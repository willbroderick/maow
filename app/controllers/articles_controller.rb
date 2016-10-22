class ArticlesController < ApplicationController
  def show
    @article = Article.includes(:source).find(params.require(:id))
    @topic = Topic.find(params.require(:topic_id))
    @industry = @topic.industry
  end

  def related
    @article = Article.find(params[:id])

    render json: if @article.similar_articles_ready
      @similar_articles = @article.similar_articles.
        includes(:source).
        limit(50).
        order('published_at DESC')
      {
        status: 'success',
        data: render_to_string('related', layout: false)
      }
    else
      {
        status: 'preparing',
        data: "Finding similar articles... (found: #{@article.similar_articles.count})"
      }
    end
  end
end
