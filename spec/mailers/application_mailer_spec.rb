require 'rails_helper'

RSpec.describe ApplicationMailer, type: :mailer do
  it 'has the default from' do
    expect(ApplicationMailer.default[:from]).to eq('from@example.com')
  end
end
