Rails.application.routes.draw do
  mount Rswag::Api::Engine => '/api-docs'
  mount Rswag::Ui::Engine => '/'
  resources :authors
  resources :socials
  resources :articles

  get "up" => "rails/health#show", as: :rails_health_check

end
