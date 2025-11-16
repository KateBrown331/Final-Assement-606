require "rails_helper"

RSpec.describe SessionsController, type: :request do
  let!(:user) do
    User.create!(
      email: "test@tamu.edu",
      password: "123456",
      first_name: "A",
      last_name: "B"
    )
  end

  describe "GET /login" do
    it "renders new for guest" do
      get login_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Login")
    end

    it "redirects logged-in user" do
      login(user)
      get login_path
      expect(response).to redirect_to(profile_path)
    end
  end

  describe "POST /login" do
    it "logs in successfully" do
      post login_path, params: { user: { email: user.email, password: "123456" } }
      expect(response).to redirect_to(profile_path)
    end

    it "renders new with error on fail" do
      post login_path, params: { user: { email: user.email, password: "WRONG" } }
      expect(response.body).to include("Invalid email or password")
    end

    it "redirects if already logged in" do
      login(user)
      post login_path, params: { user: { email: user.email, password: "123456" } }
      expect(response).to redirect_to(profile_path)
    end
  end

  describe "DELETE /logout" do
    it "logs out user" do
      login(user)
      delete logout_path
      expect(response).to redirect_to(login_path)
    end
  end
end
