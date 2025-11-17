require 'rails_helper'

RSpec.describe "company_verifications/edit", type: :view do
  before(:each) do
    @company_verification = assign(:company_verification, CompanyVerification.create!(
      company_email: "MyString",
      company_name: "MyString",
      is_verified: false,
      verification_token: "MyString"
    ))
  end

  it "renders the edit company_verification form" do
    render

    assert_select "form[action=?][method=?]", company_verification_path(@company_verification), "post" do

      assert_select "input[name=?]", "company_verification[company_email]"

      assert_select "input[name=?]", "company_verification[company_name]"

      assert_select "input[name=?]", "company_verification[is_verified]"

      assert_select "input[name=?]", "company_verification[verification_token]"
    end
  end
end
