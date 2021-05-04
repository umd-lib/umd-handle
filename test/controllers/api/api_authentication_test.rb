# frozen_string_literal: true

require 'test_helper'

module Api
  # JWT Token Authentication tests for the REST API
  class ApiAuthenticationTest < ActionController::TestCase
    include Devise::Test::ControllerHelpers

    def setup
      @controller = Api::V1::HandlesController.new
      @jwt_secret = 'jwt_secret_for_tests'
      Rails.application.config.jwt_secret = @jwt_secret
      @path_params = { prefix: '1903.1', suffix: '1' }
    end

    test 'requests without Authorization header are rejected' do
      get :show, params: @path_params, format: :json
      assert_response :unauthorized
    end

    test 'requests without "Bearer" in the Authorization header are rejected' do
      request.headers['Authorization'] = 'NOT_VALID'

      get :show, params: @path_params, format: :json
      assert_response :unauthorized
    end

    test 'requests without valid JWT in the Authorization header are rejected' do
      request.headers['Authorization'] = 'Bearer NOT.VALID.JWT'

      get :show, params: @path_params, format: :json
      assert_response :unauthorized
    end

    test 'JWT tokens with empty payload are rejected' do
      payload = {}
      jwt_token = JWT.encode(payload, @jwt_secret, 'HS256')
      request.headers['Authorization'] = "Bearer #{jwt_token}"

      get :show, params: @path_params, format: :json
      assert_response :unauthorized
    end

    test 'requests without expected JWT payload in the Authorization header are rejected' do
      payload = { foo: 'bar' }
      jwt_token = JWT.encode(payload, @jwt_secret, 'HS256')
      request.headers['Authorization'] = "Bearer #{jwt_token}"

      get :show, params: @path_params, format: :json
      assert_response :unauthorized
    end

    test 'requests with expected JWT payload in the Authorization header are accepted' do
      payload = { role: 'rest_api' }
      jwt_token = JWT.encode(payload, @jwt_secret, 'HS256')
      request.headers['Authorization'] = "Bearer #{jwt_token}"

      get :show, params: @path_params, format: :json
      assert_response :success
    end
  end
end
