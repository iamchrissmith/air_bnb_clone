Rails.application.routes.draw do
  root 'home#index'

  namespace :api, defaults: {format: :json} do
    namespace :v1 do
      namespace :properties do
        get 'most_guests', to: 'most_guests#index'
      end
      namespace :reservations do
        get '/by_month', to: 'month#index'
      end
      namespace :users do
        namespace :reservations do
          get '/nights', to: 'nights#index'
          get '/bookings', to: 'bookings#index'
        end
        namespace :properties do
          get '/most_properties', to: 'most_properties#index'
        end
        namespace :money do
          get '/most_spent', to: 'most_spent#index'
          get '/most_revenue', to: 'most_revenue#index'
        end
      end
    end
  end

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks"}
  get '/sign_up', to: 'signup#index'
  get '/log_in', to: 'login#index'
  get  '/dashboard', to: 'dashboard#index'
  delete '/logout', to: 'sessions#destroy'

  resources :users, only: [:edit, :update, :show]

  resources :properties,  only: [:index, :show]

  resources :reservations, only: [:new]

end
