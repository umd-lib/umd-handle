# frozen_string_literal: true

require 'test_helper'

# Tests for JwtTokenLog model
class JwtTokenLogTest < ActiveSupport::TestCase
  test 'non-empty description is required' do
    jwt_token = JwtTokenLog.new(token: 'abc', description: nil)
    assert_not jwt_token.valid?

    jwt_token = JwtTokenLog.new(token: 'abc', description: '')
    assert_not jwt_token.valid?

    jwt_token = JwtTokenLog.new(token: 'abc', description: '   ')
    assert_not jwt_token.valid?

    jwt_token = JwtTokenLog.new(token: 'abc', description: 'description')
    assert jwt_token.valid?
  end
end
