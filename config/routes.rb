Rails.application.routes.draw do
  devise_for :users
  root 'home#index'

  get '/sign_up', to: 'users#new'
  get '/log_in', to: 'sessions#new'
  get '/auth/facebook', as: :facebook_login
  get '/auth/google_oauth2', as: :google_login
  get '/auth/:provider/callback', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

end
