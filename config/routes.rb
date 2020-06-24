Rails.application.routes.draw do

  devise_for :users
  root to: 'pages#home'

  resources :users, only: [:index, :edit, :update]
  resources :areas, only: [:index, :show]
  resources :funds, only: [:index, :show]
  resources :daily_data, only: [:index]

  # Sidekiq Web UI, only for admins.
  require "sidekiq/web"
  authenticate :user, lambda { |u| u.admin } do
    mount Sidekiq::Web => '/sidekiq'
  end
end
