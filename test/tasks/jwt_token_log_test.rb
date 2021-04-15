# frozen_string_literal: true

require 'test_helper'
require 'rake'

# Tests for "jwt" Rake tasks
class JwtTokenLogTest < ActiveSupport::TestCase
  setup do
    # Load Rake tasks, but only once
    UmdHandle::Application.load_tasks if Rake::Task.tasks.empty?
    Rails.application.config.jwt_secret = 'jwt_secret_for_tests'
  end

  test 'record of created token is logged' do
    expected_token_pattern = /^[[:alnum:]]+.[[:alnum:]]+.[[:alnum:]]+/
    assert_output(expected_token_pattern) do
      description = 'test_token'
      assert_difference('JwtTokenLog.count') do
        Rake::Task['jwt:create_token'].invoke(description)
      end
    end
  end

  test 'create_token with no description displays error and token is not logged' do
    assert_no_difference('JwtTokenLog.count') do
      assert_output('', /^ERROR: Validation failed/) do
        Rake::Task['jwt:create_token'].invoke('')
      end
    end
  end

  test 'create_token with undefined JWT secret displays error and token is not logged' do
    Rails.application.config.jwt_secret = ''
    assert_no_difference('JwtTokenLog.count') do
      assert_output('', /^ERROR: JWT Secret is not defined./) do
        Rake::Task['jwt:create_token'].invoke('test token')
      end
    end
  end

  test 'list_tokens shows message when no tokens exist' do
    # Clear all existing JwtTokenLog records
    JwtTokenLog.destroy_all

    assert_equal(0, JwtTokenLog.all.size)

    assert_output("No token log entries found!\n") do
      Rake::Task['jwt:list_tokens'].invoke
    end
  end

  test 'list_tokens shows a list of created tokens when tokens exist' do
    # Clear all existing JwtTokenLog records
    JwtTokenLog.destroy_all

    # Create two tokens
    create_token('abc', 'Token 1')
    create_token('abc', 'Token 2')

    assert_equal(2, JwtTokenLog.all.size)

    assert_output(/.*Token 1.*Token 2.*/m) do
      Rake::Task['jwt:list_tokens'].invoke
    end
  end

  teardown do
    # Need to renable all Rake tasks run in more than once
    Rake::Task['jwt:create_token'].reenable
    Rake::Task['jwt:list_tokens'].reenable
  end
end
