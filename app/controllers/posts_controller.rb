# frozen_string_literal: true

class PostsController < ApplicationController
  def index
    @posts = Post.all
  end

  def new
    @post = Post.new
    @category_posts = post.category_posts.build
  end

  def create
    @post = current_user.posts.new(post_params)
    create_or_update_category_posts
    if post.save
      redirect_to edit_post_path(post)
      flash[:success] = 'Create post successfully'
    else
      flash[:danger] = 'There was an error in creating new post'
      render :new
    end
  end

  def show
    @post = Post.with_rich_text_content_and_embeds.find_by(id: params[:id])
  end

  def edit
    @post = Post.with_rich_text_content_and_embeds.find_by(id: params[:id])
  end

  def update
    @post = current_user.posts.find_by(id: params[:id])
    create_or_update_category_posts
    if post.update(post_params)
      redirect_to edit_post_path(post)
      flash[:success] = 'Edit post successfully'
    else
      flash[:danger] = 'There was an error in editing the post'
      render :edit
    end
  end

  def destroy; end

  private

  attr_reader :post

  def post_params
    params.require(:post).permit(:title, :content, :user_id)
  end

  def create_or_update_category_posts
    post.category_posts.destroy_all
    category_ids = params.dig(:post, :category_ids).reject(&:blank?)
    category_ids.each do |category_id|
      post.category_posts.build(category_id: category_id)
    end
  end
end
