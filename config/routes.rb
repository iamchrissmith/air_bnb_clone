Rails.application.routes.draw do
  root 'home#index'
    
  get '/auth/:provider', as: :provider_login
  get '/auth/:provider/callback', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

end
