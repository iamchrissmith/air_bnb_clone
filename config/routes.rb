Rails.application.routes.draw do
  root 'home#index'

  namespace :api, defaults: {format: :json} do
    namespace :v1 do
      namespace :properties do
        get 'most_guests', to: 'most_guests#index'
        get 'most_expensive', to: 'most_expensive#index'
        scope ':property_id' do
          resources :reservations, only: [:create]
        end

        resources :properties, only: [:index]
      end
      namespace :reservations do
        get '/by_month', to: 'month#index'
        get '/revenue_by_month', to: 'revenue_by_month#index'
        get '/highest_revenue_cities', to: 'cities_revenue#index'
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

  namespace :admin do
    resources :dashboard, only: [:index]
    resources :properties, only: [:index, :edit, :update]
    resources :users, only: [:index]
  end

  resources :users, only: [:edit, :update, :show]

  resources :properties,  only: [:index, :show, :new, :create, :edit, :update, :destroy] do
    resources :property_availabilities, only: [:index, :new, :create, :edit, :update, :destroy]
  end

  resources :reservations, only: [:new]

  namespace :user do
    resources :properties, only: [:index, :show]
  end

end
