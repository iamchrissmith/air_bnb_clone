Rails.application.routes.draw do
  get 'signup/index'

  root 'home#index'

  get '/signup', to: 'signup#index'

  get '/auth/facebook', as: :facebook_login
  get '/auth/google', as: :google_login
  get '/auth/:provider/callback', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

end
