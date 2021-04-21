# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'users#index'

  resources :users, only: %i[index] do
    collection do
      get :new, path: :sign_up, as: :sign_up
      post :create, path: :sign_up
    end
  end

  resources :sessions, only: %i[index create], path: :sign_in, as: :sign_in
end
