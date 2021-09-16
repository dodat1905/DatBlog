Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users
      resources :posts do
        collection do
          post 'upload_images'
        end
      end
      resources :tags
      resources :sessions
      resources :password_resets, only: :create
      resources :notifications
      post '/reset_password', to: 'password_resets#update'
      patch '/reset_password', to: 'password_resets#reset_password'
      post '/check_login', to: 'api#authorize_request'
      get '/search', to: 'searchs#index'
    end
  end
  get 'auth/google_oauth2/callback', to: 'omniauth#google'
  get 'login_with_google', to: 'omniauth#index'
  get 'auth/facebook_oauth2/callback', to: 'omniauth#facebook'
  mount ActionCable.server => '/cable'
end
