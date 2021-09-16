# frozen_string_literal: true

module Api
  module V1
    class NotificationsController < Api::V1::ApiController
      before_action :authorize_request

      def index
        @notifications = Notification.includes(:sender, :receiver).order(created_at: :desc)
        render json: notifications, root: :notifications, adapter: :json, status: :ok
      end

      def show; end

      def update
        @notification = Notification.find(params[:id])
        notification.update(unread: false)
      end

      private

      attr_reader :notifications, :notification
    end
  end
end
