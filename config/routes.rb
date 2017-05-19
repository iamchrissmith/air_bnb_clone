Rails.application.routes.draw do
  # devise_for :users
  root 'home#index'

  get '/sign_up', to: 'signup#index'
  get '/log_in', to: 'login#index'

  get '/auth/facebook', as: :facebook_login

  # get '/auth/google', as: :google_login
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks"}
  get '/auth/:provider/callback', to: 'sessions#create'
  # get '/users/auth/google_oauth2/callback', to: 'sessions#create'
  get  '/dashboard', to: 'dashboard#index'
  delete '/logout', to: 'sessions#destroy'

  resources :users, only: [:edit, :update]
end
