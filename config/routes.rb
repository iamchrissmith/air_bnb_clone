Rails.application.routes.draw do
  root 'home#index'

  get '/auth/facebook', as: :facebook_login
  get '/signup', to: 'signup#index'
  get '/auth/google_oauth2', as: :google_login
  get '/auth/:provider/callback', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  get  '/dashboard', to: 'dashboard#index'
  resources :users, only: [:edit, :update]
end
