Rails.application.routes.draw do

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks', sessions: 'users/sessions' }
  devise_scope :user do
    match '/users/auth/saml', to: 'users/omniauth_callbacks#passthru', as: :user_omniauth_authorize, via: [:get, :post]
    match '/users/auth/saml/callback', to: 'users/omniauth_callbacks#saml', as: "user_omniauth_callback_saml".to_sym, via: [:get, :post]
    get 'users/sign_in', to: 'users/sessions#new', as: :new_user_session
    get 'users/sign_out', to: 'users/sessions#destroy', as: :destroy_user_session
    get 'users/unauthorized', to: 'users/sessions#unauthorized', as: :unauthorized_user
  end

  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      constraints(prefix: /[^\/]+/) do # Allow prefixes to contain "."
        get 'handles/:prefix/:suffix' => 'handles#show', as: :handle
        post 'handles' => 'handles#create', as: :new_handle
      end
    end
  end

  resources :handles
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'home#index'

  get '/ping' => 'ping#verify'
end
