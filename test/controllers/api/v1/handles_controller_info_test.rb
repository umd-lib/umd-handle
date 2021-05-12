# frozen_string_literal: true

require 'test_helper'

module Api
  module V1
    # Controller tests for the "info" Handles REST endpoint
    class HandlesControllerInfoTest < ActionController::TestCase
      include Devise::Test::ControllerHelpers
      def setup
        use_jwt_token
        @controller = Api::V1::HandlesController.new
        Rails.application.config.handle_http_proxy_base = 'http://test.example.com/'
        @request.headers['ACCEPT'] = 'application/json'
      end

      test 'info returns 401 (Unauthorized) when authentication token not provided' do
        @request.headers['Authorization'] = ''
        get :info, params: { prefix: handles(:one).prefix, repo_id: handles(:one).suffix }
        assert_response :unauthorized
      end

      test 'info returns 400 (Bad Request) when there are no parameters' do
        # No parameters
        get :info

        assert_response :bad_request
        parsed_response = JSON.parse(@response.body)
        errors = parsed_response['errors']
        assert_equal 2, errors.count
        assert errors.include?('"prefix" is required')
        assert errors.include?('"suffix" is required')
      end

      test 'info returns 400 (Bad Request) when "prefix" parameter not provided' do
        get :info, params: { suffix: '1' }

        assert_response :bad_request
        parsed_response = JSON.parse(@response.body)
        errors = parsed_response['errors']
        assert_equal 1, errors.count
        assert errors.include?('"prefix" is required')
      end

      test 'info returns 400 (Bad Request) when "suffix" parameter not provided' do
        get :info, params: { prefix: '1903.1' }

        assert_response :bad_request
        parsed_response = JSON.parse(@response.body)
        errors = parsed_response['errors']
        assert_equal 1, errors.count
        assert errors.include?('"suffix" is required')
      end

      test 'info returns false when associated handle does not exist' do
        prefix = 'nonexistent_prefix'
        suffix = 'nonexistent_suffix'
        get :info, params: { prefix: prefix, suffix: suffix }

        assert_response :success
        parsed_response = JSON.parse(@response.body)
        assert_equal false, parsed_response['exists']
        assert_equal prefix, parsed_response['request']['prefix']
        assert_equal suffix, parsed_response['request']['suffix']

        # Following keys should not be present, as they are empty
        assert_not parsed_response.key?('repo')
        assert_not parsed_response.key?('repo_id')
        assert_not parsed_response.key?('url')
        assert_not parsed_response.key?('handle_url')
      end

      test 'info returns true when associated handle does exist' do
        expected_handle = handles(:one)
        prefix = expected_handle.prefix
        suffix = expected_handle.suffix
        get :info, params: { prefix: prefix, suffix: suffix }

        expected_handle_url = "http://test.example.com/#{prefix}/#{suffix}"
        assert_response :success
        parsed_response = JSON.parse(@response.body)
        assert_equal true, parsed_response['exists']
        assert_equal expected_handle_url, parsed_response['handle_url']
        assert_equal expected_handle.repo, parsed_response['repo']
        assert_equal expected_handle.repo_id, parsed_response['repo_id']
        assert_equal expected_handle.url, parsed_response['url']
        assert_equal prefix, parsed_response['request']['prefix']
        assert_equal suffix.to_s, parsed_response['request']['suffix']
      end
    end
  end
end
