class SessionsController < ApplicationController

  def create
    require "pry"; binding.pry
    if user = User.from_omniauth(request.env["omniauth.auth"])

      session[:user_id] = user.id
      redirect_to dashboard_path
    else
      redirect_to signup_path
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end

end
