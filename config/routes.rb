Rails.application.routes.draw do
  root 'home#index'

  get '/sign_up', to: 'signup#index'
  get '/log_in', to: 'login#index'
  get  '/dashboard', to: 'dashboard#index'
  delete '/logout', to: 'sessions#destroy'

  devise_for :users,
    :controllers => { :omniauth_callbacks => "users/omniauth_callbacks"},
    :path_names => {
    	:verify_authy => "/verify-token",
    	:enable_authy => "/enable_authy",
    	:verify_authy_installation => "/verify-installation"
      }

  resources :users, only: [:edit, :update]

  resources :properties,  only: [:index, :show]

end
