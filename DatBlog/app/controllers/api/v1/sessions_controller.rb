# frozen_string_literal: true

module Api
  module V1
    class SessionsController < Api::V1::ApiController
      before_action :authorize_request, except: :create

      def create
        @user = User.find_by name: params[:name]
        if user.present? && user.authenticate(params[:password])
          token = JsonWebToken.encode(user_id: user.id)
          hours = params[:remember] == true ? 168.hours.from_now.in_time_zone.to_i : 24.hours.from_now.in_time_zone.to_i
          refresh_token = JsonWebToken.encode(user_id: user.id, exp: hours)
          render json: { message: 'Login user successfully!', token: token, refresh_token: refresh_token,
                         user: ActiveModelSerializers::SerializableResource.new(@user).as_json },
                 status: :ok
        else
          render json: { message: 'Authorize failed' }, status: 404
        end
      end

      private

      attr_reader :user

      def auth
        request.env['omniauth.auth']
      end
    end
  end
end
