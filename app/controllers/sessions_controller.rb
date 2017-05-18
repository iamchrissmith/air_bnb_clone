class SessionsController < ApplicationController

  def create
    if user = User.from_google_omniauth(request.env["omniauth.auth"])

      session[:user_id] = user.id
      redirect_to edit_user_path(user)
    else
      redirect_to signup_path
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end

end
