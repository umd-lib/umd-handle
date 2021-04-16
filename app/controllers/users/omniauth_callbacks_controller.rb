# frozen_string_literal: true

# Omniauth callacks for SAML authentication
class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController # rubocop:disable Style/ClassAndModuleChildren
  skip_before_action :authenticate_user!
  protect_from_forgery with: :exception, except: :saml

  def passthru
    redirect_to new_user_session_path
  end

  def saml
    auth_hash = request.env['omniauth.auth']
    email = auth_hash.info.email.first
    roles = sanitize_saml_roles(auth_hash.info.roles || [])
    redirect_to(unauthorized_user_path) and return unless roles.include?('administrator')

    @user = User.create_or_find_by!(email: email, uid: email, provider: 'saml')
    sign_in(@user)

    redirect_to(root_path)
  end

  private

    def sanitize_saml_roles(roles)
      roles.map do |role|
        role.downcase.sub(/^handle-/, '').gsub(/-/, '_')
      end
    end
end
