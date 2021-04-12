class Users::SessionsController < Devise::SessionsController
  skip_before_action :authenticate_user!
  
  def new
    omniauth_params = params.reject { |k,v| ['controller','action'].include?(k) }
    omniauth_params.permit!
    login_path = user_omniauth_authorize_path(omniauth_params)
    redirect_to login_path
  end
end