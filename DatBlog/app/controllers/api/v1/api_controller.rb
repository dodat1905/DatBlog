# frozen_string_literal: true

module Api
  module V1
    class ApiController < ApplicationController
      skip_before_action :verify_authenticity_token

      def authorize_request
        header = request.headers['Authorization']
        refresh_token = request.headers['RefreshAuthorization']
        begin
          @current_user = User.find_by(id: JsonWebToken.decode(header)[:user_id])
        rescue ActiveRecord::RecordNotFound => e
          render json: { errors: e.message }, status: :unauthorized
        rescue JWT::DecodeError => e
          return unless e.message == 'Signature has expired'

          begin
            decoded_refresh_token = JsonWebToken.decode(refresh_token)
            user = User.find(decoded_refresh_token[:user_id])
            generate_token(user)
          rescue StandardError
            render json: { login_errors: e.message }, status: :unauthorized
          end
        end
      end

      private

      attr_reader :current_user

      def generate_token(user)
        token = JsonWebToken.encode(user_id: user.id)
        refresh_token = JsonWebToken.encode(user_id: user.id, exp: 168.hours.from_now.in_time_zone)
        render json: { message: 'Login user successfully!', token: token, refresh_token: refresh_token,
                       user: user }, status: :ok
      end
    end
  end
end
