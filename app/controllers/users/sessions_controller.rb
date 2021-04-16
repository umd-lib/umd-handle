# frozen_string_literal: true

# Controller for managing user sessions for authorization
class Users::SessionsController < Devise::SessionsController # rubocop:disable Style/ClassAndModuleChildren
  skip_before_action :authenticate_user!

  def new
    omniauth_params = params.reject { |k, _v| %w[controller action].include?(k) }
    omniauth_params.permit!
    login_path = user_omniauth_authorize_path(omniauth_params)
    redirect_to login_path
  end

  def unauthorized
    render status: :unauthorized
  end
end
