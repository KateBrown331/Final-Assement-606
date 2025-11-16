class SessionsController < ApplicationController
  before_action :redirect_if_logged_in, only: [:new, :create]
  def new
    # Renders login form
  end

  def create
    # Look up user by email
    user = User.find_by(email: params[:user][:email])
    
    if user && user.authenticate(params[:user][:password])
      # Login success
      session[:user_id] = user.id
      redirect_to profile_path, notice: 'Logged in successfully!'
    else
      # Login failed
      flash.now[:error] = 'Invalid email or password'
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_path, notice: 'Logged out successfully!'
  end
end
