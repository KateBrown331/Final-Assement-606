require 'rails_helper'

RSpec.describe "company_verifications/show", type: :view do
  before(:each) do
    @company_verification = assign(:company_verification, CompanyVerification.create!(
      company_email: "Company Email",
      company_name: "Company Name",
      is_verified: false,
      verification_token: "Verification Token"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Company Email/)
    expect(rendered).to match(/Company Name/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/Verification Token/)
  end
end
