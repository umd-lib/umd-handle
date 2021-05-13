# frozen_string_literal: true

require 'simplecov'
require 'simplecov-rcov'
SimpleCov.formatters = [
  SimpleCov::Formatter::HTMLFormatter,
  SimpleCov::Formatter::RcovFormatter
]
SimpleCov.start 'rails'

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

# Improved Minitest output (color and progress bar)
require 'minitest/reporters'

Minitest::Reporters.use!(
  Minitest::Reporters::ProgressReporter.new,
  ENV,
  Minitest.backtrace_filter
)

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  # Commented out due to https://github.com/simplecov-ruby/simplecov/issues/718
  # parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...

  # Sets up JWT authentication to use with controller tests
  def use_jwt_token
    jwt_secret = 'jwt_secret_for_tests'
    payload = { role: 'rest_api' }
    Rails.application.config.jwt_secret = jwt_secret
    jwt_token = JWT.encode(payload, jwt_secret, 'HS256')
    request.headers['Authorization'] = "Bearer #{jwt_token}"
  end
end
