class ApplicationController < ActionController::Base
  before_action :require_login
  helper_method :current_user, :logged_in?

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def logged_in?
    !!current_user
  end

  def require_login
    allowed_paths = [ login_path, new_user_path ]
    unless logged_in? || allowed_paths.include?(request.path)
      flash[:error] = "You must be logged in to access this section"
      redirect_to login_path
    end
  end

  def redirect_if_logged_in
    redirect_to profile_path, notice: "You are already logged in" if logged_in?
  end
end
