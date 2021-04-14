# frozen_string_literal: true

require 'test_helper'

# Integration tests for Handles controller
class PingIntegrationTest < ActionDispatch::IntegrationTest
  test 'ping should succeed without authentication' do
    get ping_url
    assert_response :success
  end
end
