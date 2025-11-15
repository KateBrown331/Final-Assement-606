require 'rails_helper'
require 'securerandom'

RSpec.describe CompanyVerification, type: :model do
  let(:user) { User.create!(email: "owner+#{SecureRandom.hex(6)}@tamu.edu", password: "password", password_confirmation: "password") }

  it "is valid with a company_email and company_name" do
    cv = CompanyVerification.new(user: user, company_email: "hr@example.com", company_name: "Example Co")
    expect(cv).to be_valid
  end

  it "requires company_email to look like an email" do
    cv = CompanyVerification.new(user: user, company_email: "not-an-email", company_name: "X")
    expect(cv).not_to be_valid
    expect(cv.errors[:company_email]).to be_present
  end

  it "is unique per user for the same company_email" do
    CompanyVerification.create!(user: user, company_email: "hr@example.com", company_name: "Example Co")
    dup = CompanyVerification.new(user: user, company_email: "hr@example.com", company_name: "Example Co")
    expect(dup).not_to be_valid
  end
end
