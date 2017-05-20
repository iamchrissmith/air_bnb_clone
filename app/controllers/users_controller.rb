class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def edit
    @user = current_user
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id

      authy = Authy::API.register_user(
        email: @user.email,
        cellphone: @user.phone_number
      )
      @user.update(authy_id: authy.id)

      redirect_to account_path
    else
      render :new
    end
  end

  def update
    @user = current_user
    if @user.update(user_params)
      redirect_to dashboard_path
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :image_url, :phone_number, :description, :hometown)
  end

end
