class ApplicationController < ActionController::Base
  require 'will_paginate/array'

  protect_from_forgery with: :exception
  protect_from_forgery with: :null_session

  before_action :configure_permitted_parameters, if: :devise_controller?
  helper_method :resource_name, :resoure, :devise_mapping, :resource_class

  helper_method :searching?

  protected

  def configure_permitted_parameters
    added_attrs = [:full_name, :username, :email, :password, :password_confirmation, :remember_me]

    devise_parameter_sanitizer.permit(:sign_up, keys: added_attrs)
    devise_parameter_sanitizer.permit(:sign_in, keys: added_attrs)
    devise_parameter_sanitizer.permit(:account_update, keys: added_attrs)
  end

  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def resource_class
    User
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def searching
    binding.pry
    request.path! == '/'
  end
end
