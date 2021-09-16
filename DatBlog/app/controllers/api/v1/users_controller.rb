# frozen_string_literal: true

module Api
  module V1
    class UsersController < Api::V1::ApiController
      before_action :authorize_request, except: %i[index create]
      before_action :find_users, only: %i[show update destroy]

      def index
        @users = User.all
        render json: { users: users }, status: 200
      end

      def show
        render json: { user: user }, status: 200
      end

      def create
        @user = User.new(user_params).merge(type: :User)
        if user.save
          token = JsonWebToken.encode(user_id: user.id)
          render json: { user: user, token: token, message: 'Create a user successfully' }, status: 200
        else
          render json: { errors: user.errors.full_messages, user: user }, status: 422
        end
      end

      def update
        if user.update(user_params)
          render json: { user: user, message: 'Create a user successfully' }, status: 200
        else
          render json: { errors: user.errors.full_messages, user: user }, status: 422
        end
      end

      def destroy
        if user.destroy
          render json: { message: 'Delete a user successfully' }, status: 200
        else
          render json: { errors: user.errors.full_messages, user: user }, status: 422
        end
      end

      private

      attr_reader :user, :users

      def user_params
        params.require(:user).permit(:name, :email, :password, :password_confirmation)
      end

      def find_users
        @user = User.find(params[:id])
      rescue StandardError
        render json: { errors: 'User not found' }, status: 404
      end
    end
  end
end
