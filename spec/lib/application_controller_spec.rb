require 'rails_helper'

RSpec.describe 'ApplicationController loading' do
  it 'loads the application controller class' do
    expect(defined?(ApplicationController)).to be_truthy
    expect(ApplicationController.ancestors).to include(ActionController::Base)
  end
end
