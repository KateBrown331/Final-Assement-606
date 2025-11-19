class SessionsController < ApplicationController
  before_action :redirect_if_logged_in, only: [ :new, :create ]

  def new
    # Renders login form
  end

  def create
    user = User.find_by(email: params[:email])

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to profile_path, notice: "Logged in successfully!"
    else
      flash.now[:alert] = "Invalid email or password"
      render :new
    end
  end


  def destroy
    session[:user_id] = nil
    redirect_to login_path, notice: "Logged out successfully!"
  end

  private

  def redirect_if_logged_in
    if current_user
      redirect_to profile_path, notice: "You are already logged in!"
    end
  end
end
