require 'rails_helper'

RSpec.describe "company_verifications/index", type: :view do
  before(:each) do
    assign(:company_verifications, [
      CompanyVerification.create!(
        company_email: "Company Email",
        company_name: "Company Name",
        is_verified: false,
        verification_token: "Verification Token"
      ),
      CompanyVerification.create!(
        company_email: "Company Email",
        company_name: "Company Name",
        is_verified: false,
        verification_token: "Verification Token"
      )
    ])
  end

  it "renders a list of company_verifications" do
    render
    assert_select "tr>td", text: "Company Email".to_s, count: 2
    assert_select "tr>td", text: "Company Name".to_s, count: 2
    assert_select "tr>td", text: false.to_s, count: 2
    assert_select "tr>td", text: "Verification Token".to_s, count: 2
  end
end
