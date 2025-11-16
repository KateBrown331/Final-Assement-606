# spec/views/users/show.html.erb_spec.rb
require 'rails_helper'

RSpec.describe "users/show", type: :view do
  it "renders the user's full name and email" do
    user = User.create!(
      first_name: "John",
      last_name: "Doe",
      email: "john@tamu.edu",
      password: "password",
      password_confirmation: "password"
    )

    assign(:user, user)

    render template: "users/show"

    expect(rendered).to include(user.full_name)
    expect(rendered).to include(user.email)
  end
end
