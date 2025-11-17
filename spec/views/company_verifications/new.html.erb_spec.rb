require 'rails_helper'

RSpec.describe "company_verifications/new", type: :view do
  before(:each) do
    assign(:company_verification, CompanyVerification.new(
      company_email: "MyString",
      company_name: "MyString",
      is_verified: false,
      verification_token: "MyString"
    ))
  end

  it "renders new company_verification form" do
    render

    assert_select "form[action=?][method=?]", company_verifications_path, "post" do

      assert_select "input[name=?]", "company_verification[company_email]"

      assert_select "input[name=?]", "company_verification[company_name]"

      assert_select "input[name=?]", "company_verification[is_verified]"

      assert_select "input[name=?]", "company_verification[verification_token]"
    end
  end
end
