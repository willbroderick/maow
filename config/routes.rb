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

  # fetch latest data
  get 'fetch/:id' => 'sources#fetch_all_for_industry', as: 'fetch_all_for_industry'

  # rebuild entities
  get 'rebuild/:id' => 'sources#rebuild_all_for_industry', as: 'rebuild_all_for_industry'
end
