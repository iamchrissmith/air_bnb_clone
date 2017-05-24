class ApplicationController < ActionController::Base
  require 'will_paginate/array'

  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:full_name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:full_name])
  end


  # helper_method :current_user
  #
  # def current_user
  #   @current_user ||= User.find(session[:user_id]) if session[:user_id]
  # end
  #
  # def current_user=(user)
  #   @current_user = user
  #   session[:user_id] = user.nil? ? nil : user.id
  # end

end
