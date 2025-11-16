require 'simplecov'
SimpleCov.start 'rails' do
  add_filter '/features/'
end

require 'cucumber/rails'
require 'capybara/rails'

# Ensure transactional fixtures for cucumber
World(ActiveRecord::TestFixtures)
World(Rails.application.routes.url_helpers)
