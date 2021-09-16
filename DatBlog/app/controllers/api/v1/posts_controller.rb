# frozen_string_literal: true

module Api
  module V1
    class PostsController < Api::V1::ApiController
      before_action :authorize_request, except: %i[index show]
      before_action :find_posts, only: %i[show update destroy]
      before_action :add_tags, only: %i[create]

      def index
        @posts = Post.includes(:user, :tag_posts).order(created_at: :desc).page(params[:page]).per(Settings.per_page)
        render json: { posts: { total_pages: Post.pluck(:id).size,
                                per_page: Settings.per_page,
                                data: ActiveModelSerializers::SerializableResource.new(@posts) } },
               status: :ok
      end

      def show
        render json: post, adapter: :json, status: :ok
      end

      def create
        @post = Post.new(post_params.merge(tag_posts_attributes: tag_posts_attributes))
        if post.save
          PostsService::SendNotification.new.call(post)
          render json: { post: post, message: 'Create a post successfully' }, status: :ok
        else
          render json: { errors: post.errors.full_messages, post: post }, status: :unprocessable_entity
        end
      end

      def update
        authorize post
        post.tags.destroy_all
        add_tags
        if post.update((post_params.merge(tag_posts_attributes: tag_posts_attributes)))
          render json: { post: post, message: 'Update a post successfully' }, status: :ok
        else
          render json: { errors: post.errors.full_messages, post: post }, status: :unprocessable_entity
        end
      end

      def destroy
        authorize post
        if post.destroy
          render json: { message: 'Delete a post successfully' }, status: :ok
        else
          render json: { errors: post.errors, post: post }, status: :unprocessable_entity
        end
      end

      def upload_images
        blob = ActiveStorage::Blob.create_after_upload!(io: params[:file].tempfile,
                                                        filename: params[:file].original_filename)
        render json: { location: url_for(blob) }
      end

      private

      attr_reader :post, :posts, :tag_posts_attributes

      def post_params
        params.require(:post).permit(:title, :content, :user_id, tag_posts_attributes: %i[id post_id tag_id])
      end

      def find_posts
        @post = Post.find(params[:id])
      rescue StandardError
        render json: { errors: 'Post not found' }, status: :not_found
      end

      def add_tags
        @tag_posts_attributes = []
        params[:post][:tags].each do |tag|
          tag = Tag.find_or_create_by(name: tag.downcase)
          tag_posts_attributes.push({ tag_id: tag.id })
        end
      end
    end
  end
end
