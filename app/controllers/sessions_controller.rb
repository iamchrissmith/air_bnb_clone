class SessionsController < ApplicationController

  def create
    if user = User.from_fb_omniauth(request.env["omniauth.auth"])
      session[:user_id] = user.id
    end
    redirect_to edit_user_path(user)
  end
end