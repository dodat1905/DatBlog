# frozen_string_literal: true

module Api
  module V1
    class SearchsController < Api::V1::ApiController
      before_action :authorize_request, except: %i[index]

      def index
        @posts = Post.search(params[:search])
        render json: (posts.map { |post| post["_source"] }), root: :posts, adapter: :json, status: :ok
      end

      private

      attr_reader :posts
    end
  end
end
