require 'test_helper'

class UsersIntegrationTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

    setup do
        OmniAuth.config.test_mode = true
    end

    teardown do
        OmniAuth.config.test_mode = false
    end

    test "allows handle administrator to login" do
        login_user_with_groups(users(:one), ["Handle-Administrator"])
        post user_omniauth_callback_saml_path
    
        assert_redirected_to root_path
    end

    test "disallows users without handle administrator group" do
        login_user_with_groups(users(:one), ["Other-Administrator"])
        post user_omniauth_callback_saml_path
    
        assert_redirected_to unauthorized_user_path
    end

    test "disallows users without any group" do
        login_user_with_groups(users(:one), [])
        post user_omniauth_callback_saml_path
    
        assert_redirected_to unauthorized_user_path
    end

    test "redirects users to singed_out page on sign out" do
        login_user_with_groups(users(:one), [])
        post user_omniauth_callback_saml_path
        get destroy_user_session_path
    
        assert_redirected_to user_session_ended_path
    end

    private

        def login_user_with_groups(user, groups)
          Rails.application.env_config["devise.mapping"] = Devise.mappings[user]
          Rails.application.env_config["omniauth.auth"]  = saml_mock(user, groups)
        end

        def saml_mock(user, roles)
            OmniAuth.config.mock_auth[:saml] = OmniAuth::AuthHash.new({
            provider: "saml",
            info: { 
                email: [user.email],
                roles: roles
            }
          })
        end

end