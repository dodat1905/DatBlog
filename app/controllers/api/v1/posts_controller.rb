# frozen_string_literal: true

module Api
  module V1
    class PostsController < Api::V1::ApiController
      before_action :authorize_request
      before_action :find_posts, only: %i[show update destroy]

      def index
        @posts = Post.all
        render json: { posts: posts }, status: 200
      end

      def show
        render json: { post: post }, status: 200
      end

      def create
        @post = Post.new(post_params)
        if post.save
          render json: { post: post, message: 'Create a post successfully' }, status: 200
        else
          render json: { errors: post.errors, post: post }, status: 422
        end
      end

      def update
        if post.update(post_params)
          render json: { post: post, message: 'Create a post successfully' }, status: 200
        else
          render json: { errors: post.errors, post: post }, status: 422
        end
      end

      def destroy
        if post.destroy
          render json: { message: 'Delete a post successfully' }, status: 200
        else
          render json: { errors: post.errors, post: post }, status: 422
        end
      end

      private

      attr_reader :post, :posts

      def post_params
        params.require(:post).permit(:title, :content, :user_id, tag_posts_attributes: %i[id post_id tag_id])
      end

      def find_posts
        @post = Post.find(params[:id])
      rescue StandardError
        render json: { errors: 'Post not found' }, status: 404
      end
    end
  end
end
