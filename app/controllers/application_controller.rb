# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  def authenticate_user!(_opts = {})
    return if user_signed_in?

    if request.format == :json
      head :unauthorized
    else
      redirect_to new_user_session_path
    end
  end

  def after_sign_out_path_for(_resource)
    "#{user_omniauth_authorize_path}/spslo"
  end
end
