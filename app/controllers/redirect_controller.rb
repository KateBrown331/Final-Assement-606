class RedirectController < ApplicationController
  # Catch-all redirect action
  def fallback
    if logged_in?
      redirect_to profile_path, notice: "Redirected to your profile."
    else
      redirect_to login_path, alert: "Page not found. Please log in."
    end
  end
end
