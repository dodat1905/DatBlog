# frozen_string_literal: true

module Api
  module V1
    class PasswordResetsController < Api::V1::ApiController
      def create
        @user = User.find_by(email: params[:email])
        if @user.present?
          reset_token = User.new_token
          user.create_reset_digest(reset_token)
          user.send_password_reset_email(reset_token)
          render json: { message: 'Password reset link has been sent to your email' }, status: 200
        else
          render json: { error: 'Email not found!' }, status: 404
        end
      end

      def update
        @user = User.find_by(email: params[:email])
        begin
          raise unless user.reset_password_at + 1.day >= Time.current.in_time_zone

          render json: {}, status: 200 if BCrypt::Password.new(@user.reset_digest) == params[:token]
        rescue StandardError
          render json: { message: 'Password reset link has expired' }, status: 404
        end
      end

      def reset_password
        @user = User.find_by(email: params[:email])
        if user.update(password: params[:password], password_confirmation: params[:password_confirmation])
          user.update(reset_digest: nil, reset_password_at: nil)
          render json: { message: 'Update password successfully' }, status: 200
        else
          render json: { errors: @user.errors.full_messages }, status: 422
        end
      end

      private

      attr_reader :user
    end
  end
end
