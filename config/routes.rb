Rails.application.routes.draw do
  get 'signup/index'

  root 'home#index'

  get '/signup', to: 'signup#index'
  get '/login', to: 'login#index'
  get '/dashboard', to: 'dashboard#index'
  get '/auth/facebook', as: :facebook_login
  get '/auth/google', as: :google_login
  get '/auth/:provider/callback', to: 'sessions#create'

  resources :user, only: [:edit, :update]

  delete '/logout', to: 'sessions#destroy'

end
