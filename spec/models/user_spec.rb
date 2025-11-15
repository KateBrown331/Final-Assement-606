require 'rails_helper'

RSpec.describe User, type: :model do
  subject do
    described_class.new(
      email: "test@tamu.edu",
      password: "password",
      password_confirmation: "password",
      first_name: "Test",
      last_name: "User"
    )
  end

  it "is valid with valid attributes" do
    expect(subject).to be_valid
  end

  it "requires an @tamu.edu email" do
    subject.email = "notvalid@example.com"
    expect(subject).not_to be_valid
    expect(subject.errors[:email]).to be_present
  end

  it "stores a password_digest when password is set" do
      subject.save!
      expect(subject.password_digest).to be_present
  end

  it 'generates a tamu_verification_token on create' do
    u = User.create!(email: "verify+#{SecureRandom.hex(6)}@tamu.edu", password: 'password', password_confirmation: 'password', first_name: 'A', last_name: 'B')
    expect(u.tamu_verification_token).to be_present
  end

  it 'returns full_name' do
    subject.first_name = 'First'
    subject.last_name = 'Last'
    expect(subject.full_name).to eq('First Last')
  end
end
