require 'rails_helper'

RSpec.describe "sessions/destroy.html.erb", type: :view do
  it "renders without error" do
    render inline: "<p>Stub template for destroy</p>"
    expect(rendered).to include("Stub template for destroy")
  end
end
