class UsersController < ApplicationController
  before_action :redirect_if_logged_in, only: [:new, :create]
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to profile_path, notice: 'Account created successfully!'
    else
      render :new
    end
  end

  def show
    @user = current_user
    redirect_to login_path, alert: 'Please log in first' unless @user
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :first_name, :last_name)
  end
end
