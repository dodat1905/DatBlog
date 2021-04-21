# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root "users#index"

  resources :users do
    collection do
      get :sign_in
      post :sign_in
      get :sign_up
      post :sign_up
    end
  end
end
