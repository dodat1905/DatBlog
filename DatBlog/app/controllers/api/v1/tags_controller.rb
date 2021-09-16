# frozen_string_literal: true

module Api
  module V1
    class TagsController < Api::V1::ApiController
      def index
        @tags = Tag.all
        render json: { tags: tags }, status: 200
      end

      private

      attr_reader :tag, :tags
    end
  end
end
