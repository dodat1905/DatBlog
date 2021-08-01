# frozen_string_literal: true

module Api
  module V1
    class ApiController < ApplicationController
      def authorize_request
        header = request.headers['Authorization']
        begin
          decoded = JsonWebToken.decode(header)
          @current_user = User.find(decoded[:user_id])
        rescue ActiveRecord::RecordNotFound => e
          render json: { errors: e.message }, status: :unauthorized
        rescue JWT::DecodeError => e
          render json: { errors: e.message }, status: :unauthorized
        end
      end

      private

      attr_reader :current_user
    end
  end
end
