require "rails_helper"

RSpec.describe "ApplicationController methods", type: :request do
  let!(:user) do
    User.create!(
      email: "test@tamu.edu",
      password: "123456",
      first_name: "A",
      last_name: "B"
    )
  end

  describe "#require_login" do
    it "redirects guest to login when accessing protected pages" do
      get profile_path
      expect(response).to redirect_to(login_path)
      expect(flash[:error]).to eq("You must be logged in to access this section")
    end

    it "allows logged-in user to access protected pages" do
      post login_path, params: { user: { email: user.email, password: "123456" } }
      follow_redirect! # Follow to profile page

      get profile_path
      expect(response).to have_http_status(:success)
      expect(response.body).to include(user.email)
    end

    it "allows access to login page without login" do
      get login_path
      expect(response).to have_http_status(:success)
      expect(response.body).to include("Log In")
    end

    it "allows access to signup page without login" do
      get signup_path
      if response.redirect?
        follow_redirect!
      end
      expect(response).to have_http_status(:success)
      expect(response.body).to include("Sign Up")
    end
  end

  describe "#redirect_if_logged_in" do
    it "redirects logged-in user away from login page" do
      post login_path, params: { user: { email: user.email, password: "123456" } }
      follow_redirect! # Follow to profile page

      get login_path
      expect(response).to redirect_to(profile_path)
    end

    it "redirects logged-in user away from signup page" do
      post login_path, params: { user: { email: user.email, password: "123456" } }
      follow_redirect! # Follow to profile page

      get signup_path
      expect(response).to redirect_to(profile_path)
    end

    it "allows guests to access login page" do
      get login_path
      expect(response).to have_http_status(:success)
      expect(response.body).to include("Log In")
    end

    it "allows guests to access signup page" do
      get signup_path
      if response.redirect?
        follow_redirect!
      end
      expect(response).to have_http_status(:success)
      expect(response.body).to include("Sign Up")
    end
  end
end
