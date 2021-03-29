# frozen_string_literal: true

require 'test_helper'
require 'minitest/autorun'

class PingControllerTest < ActionController::TestCase
  test 'verify returns success response when health is okay' do
    get :verify
    assert_equal 200, response.status
    assert_equal 'Application is OK', response.body
  end

  test 'verify returns error message when health is not okay' do
    stub = MiniTest::Mock.new
    stub.expect :with_connection, false
    ActiveRecord::Base.stub :connection_pool, stub do
      get :verify
      assert_equal 503, response.status
      assert_equal 'Cannot connect to database!', response.body
    end
  end
end
