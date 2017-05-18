class SessionsController < ApplicationController

  def create

    if user = User.from_fb_omniauth(request.env["omniauth.auth"])
      session[:user_id] = user.id
      if current_user.phone_number.nil?
        redirect_to edit_user_path(user)
      else
        redirect_to dashboard_path
      end
    end
  end

end
