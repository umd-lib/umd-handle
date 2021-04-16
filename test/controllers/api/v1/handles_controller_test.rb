# frozen_string_literal: true

require 'test_helper'

module Api
  module V1
    # Controller tests for the Handles REST API
    class HandlesControllerTest < ActionController::TestCase
      include Devise::Test::ControllerHelpers
      def setup
        use_jwt_token
      end

      test 'show returns 404 when handle is not found' do
        @path_params = { prefix: 'NON-EXISTENT PREFIX', suffix: '42' }

        get :show, params: @path_params, format: :json

        assert_equal 404, response.status
      end

      test 'show returns resolved URL when handle is found' do
        one = handles(:one)
        @path_params = { prefix: one.prefix, suffix: one.suffix }

        get :show, params: @path_params, format: :json

        parsed_response = JSON.parse response.body
        assert_equal one.url, parsed_response['url']
      end
    end
  end
end
