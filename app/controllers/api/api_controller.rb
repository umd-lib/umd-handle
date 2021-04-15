# frozen_string_literal: true

module Api
  # Base class for REST API Controllers
  class ApiController < ActionController::Base # rubocop:disable Rails/ApplicationController
    before_action :authenticate_request!

    def authenticate_request!(_opts = {})
      # head :unauthorized unless (request.format == :json && request_authenticated(request))
      jwt_token = get_jwt_token(request)
      head :unauthorized unless verify_jwt_token(jwt_token)
    rescue StandardError => e
      Rails.logger.error("Error decoding JWT token: #{e}")
      head :unauthorized
    end

    # Returns the JWT token from the given request, or raises an ArgumentError
    # if a JWT token cannot be retrieved from the request.
    def get_jwt_token(request)
      # Retrieve JWT token from header
      auth_header = request.authorization
      raise ArgumentError('Authorization header not provided in request') unless auth_header

      pattern = /^Bearer /
      unless auth_header.match(pattern)
        raise ArgumentError("Authorization header format not recognized: #{auth_header}")
      end

      auth_header.gsub(pattern, '')
    end

    # Verifies that the given JWT token is valid, and has the required
    # payload to authenticate the request.
    def verify_jwt_token(jwt_token)
      # Verify that the JWT token is valid
      jwt_secret = Rails.application.config.jwt_secret

      decoded_token = JWT.decode(jwt_token, jwt_secret, true, { algorithm: 'HS256' })
      if decoded_token && decoded_token[0]
        payload = decoded_token[0]
        role = payload['role']
        return role == 'rest_api'
      end
      false
    end
  end
end
