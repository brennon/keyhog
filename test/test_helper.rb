ENV["RAILS_ENV"] = "test"
if ENV["COVERAGE"]
  require 'simplecov'
  SimpleCov.start 'rails' if ENV["COVERAGE"]
end

require File.expand_path('../../config/environment', __FILE__)

require 'rails/test_help'
require 'capybara/rails'
require 'mocha/setup'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...
end

class ActionDispatch::IntegrationTest
  # Make the Capybara DSL available in all integration tests
  include Capybara::DSL
end
