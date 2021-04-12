Rails.application.routes.draw do
  devise_for :users
  resources :handles
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'home#index'

  get '/ping' => 'ping#verify'
end
