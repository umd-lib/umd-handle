# frozen_string_literal: true

require 'test_helper'

module Api
  module V1
    # Controller tests for the "exists" Handles REST endpoint
    class HandlesControllerExistsTest < ActionController::TestCase
      include Devise::Test::ControllerHelpers
      def setup
        use_jwt_token
        @controller = Api::V1::HandlesController.new
        Rails.application.config.handle_http_proxy_base = 'http://test.example.com/'
        @request.headers['ACCEPT'] = 'application/json'
      end

      test 'exists returns 401 (Unauthorized) when authentication token not provided' do
        @request.headers['Authorization'] = ''
        get :exists, params: { repo: handles(:one).repo, repo_id: handles(:one).repo_id }
        assert_response :unauthorized
      end

      test 'exists returns 400 (Bad Request) when there are no parameters' do
        # No parameters
        get :exists

        assert_response :bad_request
        parsed_response = JSON.parse(@response.body)
        errors = parsed_response['errors']
        assert_equal 2, errors.count
        assert errors.include?('"repo" is required')
        assert errors.include?('"repo_id" is required')
      end

      test 'exists returns 400 (Bad Request) when "repo" parameter not provided' do
        get :exists, params: { repo_id: 'umd:327543' }

        assert_response :bad_request
        parsed_response = JSON.parse(@response.body)
        errors = parsed_response['errors']
        assert_equal 1, errors.count
        assert errors.include?('"repo" is required')
      end

      test 'exists returns 400 (Bad Request) when "repo_id" parameter not provided' do
        get :exists, params: { repo: 'fedora2' }

        assert_response :bad_request
        parsed_response = JSON.parse(@response.body)
        errors = parsed_response['errors']
        assert_equal 1, errors.count
        assert errors.include?('"repo_id" is required')
      end

      test 'exists returns false when associated handle does not exist' do
        repo = 'nonexistent_repo'
        repo_id = 'nonexistent_repo_id'
        get :exists, params: { repo: repo, repo_id: repo_id }

        assert_response :success
        parsed_response = JSON.parse(@response.body)
        assert_equal false, parsed_response['exists']
        assert_equal repo, parsed_response['request']['repo']
        assert_equal repo_id, parsed_response['request']['repo_id']

        # Following keys should not be present, as they are empty
        assert_not parsed_response.key?('prefix')
        assert_not parsed_response.key?('suffix')
        assert_not parsed_response.key?('url')
        assert_not parsed_response.key?('handle_url')
      end

      test 'exists returns true when associated handle does exist' do
        repo = 'aspace'
        repo_id = 'aspace_pid::1'
        get :exists, params: { repo: repo, repo_id: repo_id }

        assert_response :success
        parsed_response = JSON.parse(@response.body)
        assert_equal true, parsed_response['exists']
        assert_equal 'http://test.example.com/1903.1/1', parsed_response['handle_url']
        assert_equal '1903.1', parsed_response['prefix']
        assert_equal '1', parsed_response['suffix']
        assert_equal 'http://example.com/test/one', parsed_response['url']
        assert_equal repo, parsed_response['request']['repo']
        assert_equal repo_id, parsed_response['request']['repo_id']
      end
    end
  end
end
