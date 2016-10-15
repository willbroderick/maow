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

  # rebuild entities
  get 'rebuild/:id' => 'sources#rebuild_all_for_industry', as: 'rebuild_all_for_industry'

  # assess entity importance
  get 'reassess_entities/:id' => 'entities#reassess_all_for_industry', as: 'reassess_all_for_industry'
end
