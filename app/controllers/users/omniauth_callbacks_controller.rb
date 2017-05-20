class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def facebook
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted?
      sign_in @user, :event => :authentication
      set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
      if @user.phone_number.nil?
        redirect_to edit_user_path(@user)
      else

        redirect_to dashboard_path
      end
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to root_path
    end
  end

  def google_oauth2
    @user = User.from_omniauth(request.env["omniauth.auth"])


    if @user.persisted?
      sign_in @user, :event => :authentication
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Google"
      if @user.phone_number.nil?
        redirect_to edit_user_path(@user)
      else

        redirect_to dashboard_path
      end
    else
      session["devise.google_data"] = request.env["omniauth.auth"].except(:extra)
      redirect_to dashboard_path
    end
  end
end
