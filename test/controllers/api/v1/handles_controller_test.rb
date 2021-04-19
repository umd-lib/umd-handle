# frozen_string_literal: true

require 'test_helper'

module Api
  module V1
    # Controller tests for the Handles REST API
    class HandlesControllerTest < ActionController::TestCase
      include Devise::Test::ControllerHelpers
      def setup
        use_jwt_token
        Rails.application.config.handle_http_proxy_base = 'http://test.example.com/'
        request.headers['CONTENT_TYPE'] = 'application/json'
      end

      test 'show returns 404 when handle is not found' do
        @path_params = { prefix: 'NON-EXISTENT PREFIX', suffix: '42' }

        get :show, params: @path_params, format: :json

        assert_response :not_found
      end

      test 'show returns resolved URL when handle is found' do
        one = handles(:one)
        @path_params = { prefix: one.prefix, suffix: one.suffix }

        get :show, params: @path_params, format: :json

        parsed_response = JSON.parse response.body
        assert_equal one.url, parsed_response['url']
      end

      test 'create return HTTP status 400 when provided unknown prefix' do
        body_json = create_request_body(prefix: 'NON-EXISTENT PREFIX').to_json

        post :create, body: body_json, format: :json

        assert_response :bad_request
        parsed_response = JSON.parse response.body
        assert_includes(parsed_response['errors'], "Prefix 'NON-EXISTENT PREFIX' is not a valid prefix")
      end

      test 'create return HTTP status 400 when provided unknown repo' do
        body_json = create_request_body(repo: 'NON-EXISTENT REPO').to_json

        post :create, body: body_json, format: :json

        assert_response :bad_request
        parsed_response = JSON.parse response.body
        assert_includes(parsed_response['errors'], "Repository 'NON-EXISTENT REPO' is not a valid repository")
      end

      test 'create return HTTP status 400 when a required field is missing' do
        required_fields = %i[prefix url repo repo_id]

        required_fields.each do |required_field|
          # Remove required field from body hash
          body_json = create_request_body.except(required_field).to_json

          post :create, body: body_json, format: :json

          assert_response :bad_request
          parsed_response = JSON.parse response.body
          expected_error = "#{Handle.human_attribute_name(required_field)} is required"
          assert_includes(parsed_response['errors'], expected_error)
        end
      end

      test 'create returns new handle when provided correct parameters' do
        expected_prefix = Handle.prefixes.first
        expected_suffix = Handle.group(:prefix).maximum(:suffix)[expected_prefix] + 1
        expected_handle_url = "#{Rails.application.config.handle_http_proxy_base}#{expected_prefix}/#{expected_suffix}"

        body_json = create_request_body(prefix: expected_prefix).to_json

        post :create, body: body_json, format: :json

        assert_response :success
        parsed_response = JSON.parse response.body
        expected_response = {
          suffix: expected_suffix.to_s, handle_url: expected_handle_url,
          request: {
            prefix: expected_prefix,
            repo: Handle.repos.first,
            repo_id: 'abc123',
            url: 'http://example.com/handles_controller_test'
          }.stringify_keys
        }.stringify_keys
        assert_equal(expected_response, parsed_response)
        # assert_equal(expected_prefix, parsed_response['prefix'])
        # assert_equal(expected_suffix, parsed_response['suffix'])
        # assert_equal(expected_handle_url, parsed_response['handle_url'])
      end

      def create_request_body(prefix: Handle.prefixes.first, repo: Handle.repos.first)
        {
          prefix: prefix,
          url: 'http://example.com/handles_controller_test',
          repo: repo,
          repo_id: 'abc123',
          description: 'A test URL',
          notes: 'Notes for a test URL'
        }
      end
    end
  end
end
