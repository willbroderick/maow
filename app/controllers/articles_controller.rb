include ActionView::Helpers::DateHelper

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
      time_mins = (DateTime.current.to_i - @article.rebuild_vertices_job.run_at.to_i)/60
      time_secs = (DateTime.current.to_i - @article.rebuild_vertices_job.run_at.to_i) - time_mins*60
      {
        status: 'preparing',
        data: [
          'Finding similar articles... (running for: ',
          time_mins.to_s,
          'm, ',
          time_secs.to_s,
          's)'].join('')
      }
    end
  end
end
