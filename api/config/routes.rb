Rails.application.routes.draw do
  mount Rswag::Api::Engine => '/api-docs'
  mount Rswag::Ui::Engine => '/api-docs'
  resources :authors
  resources :socials
  resources :articles do
    get :count_by_author, on: :collection
  end

  get "/tech", to: "tech#show"
  get "/liveness", to: "health#liveness"
  get "/metrics", to: "metrics#show"
  get "up" => "rails/health#show", as: :rails_health_check

  # Serve SPA index for any unmatched path
  get '*path', to: 'static#index', constraints: ->(req) { !req.xhr? && req.format.html? }

end
