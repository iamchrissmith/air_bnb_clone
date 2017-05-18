Rails.application.routes.draw do

  root 'home#index'

  get '/signup', to: 'signup#index'
  get '/login', to: 'login#index'
  get '/dashboard', to: 'dashboard#index'
  get '/auth/facebook', as: :facebook_login

  get '/auth/google', as: :google_login
  get '/auth/:provider/callback', to: 'sessions#create'

  get  '/dashboard', to: 'dashboard#index'
  delete '/logout', to: 'sessions#destroy'

  resources :users, only: [:edit, :update]
end
