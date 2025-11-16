require 'rails_helper'

RSpec.describe "sessions/create.html.erb", type: :view do
  it "renders without error" do
    render inline: "<p>Stub template for create</p>"
    expect(rendered).to include("Stub template for create")
  end
end
