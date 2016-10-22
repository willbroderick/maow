Rails.application.routes.draw do
  # admin
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  # accounts
  devise_for :users

  # homepage
  root 'industries#default'

  # landing page for an industry
  get 'industry/:id' => 'industries#landing', as: 'industry_landing'

  # viewing page for a topic
  get 'topic/:id' => 'topics#show', as: 'topic_show'

  # viewing page for an article
  get 'topic/:topic_id/article/:id' => 'articles#show', as: 'article_show'

  # json endpoint for fetching related articles
  get 'article/:id/related' => 'articles#related', as: 'related_articles'

  # rebuild entities
  get 'rebuild_entities/:id' => 'industries#rebuild_entities_for_industry', as: 'rebuild_entities_for_industry'

  # assess entity importance
  get 'reassess_entities/:id' => 'industries#reassess_entities_for_industry', as: 'reassess_entities_for_industry'
end
