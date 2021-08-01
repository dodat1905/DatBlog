# frozen_string_literal: true

module Api
  module V1
    class SessionsController < Api::V1::ApiController
      before_action :authorize_request, except: :create

      def index
      end

      def create
        @user = User.find_by name: params[:name]
        if user.present? && user.authenticate(params[:password])
          token = JsonWebToken.encode(user_id: user.id)
          render json: { message: 'Login user successfully!', token: token }, status: :ok
        else
          render json: { message: 'Authorize failed' }, status: :unauthorized
        end
      end

      private

      attr_reader :user
    end
  end
end
