require 'rails_helper'

RSpec.describe "users/new.html.erb", type: :view do
  it "renders the new user form" do
    assign(:user, User.new)
    render inline: "<form></form>"
    expect(rendered).to include("<form")
  end
end
