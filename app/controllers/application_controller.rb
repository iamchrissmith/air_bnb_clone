class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  # before_action :ensure_authy_enabled

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:full_name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:full_name])
  end

  private

  def ensure_authy_enabled
   if current_user and !current_user.authy_enabled?
     redirect_to user_enable_authy_path
   end
  end
end
