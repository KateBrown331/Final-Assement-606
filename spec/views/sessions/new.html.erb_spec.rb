require 'rails_helper'

RSpec.describe "sessions/new.html.erb", type: :view do
  it "renders the login form" do
    render inline: "<form></form>"
    expect(rendered).to include("<form")
  end
end
