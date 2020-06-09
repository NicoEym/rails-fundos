Rails.application.routes.draw do

  devise_for :users
  root to: 'pages#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :areas, only: [:index, :show]
  resources :funds, only: [:index, :show]
  resources :daily_data, only: [:index]
end
