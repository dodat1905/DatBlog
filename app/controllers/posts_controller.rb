# frozen_string_literal: true

class PostsController < ApplicationController
  def index; end

  def new
    @post = Post.new
    session[:blob] = []
  end

  def create
    @post = current_user.posts.new(post_params)
    redirect_to @post if @post.save
  end

  def show
    @post = Post.with_rich_text_content_and_embeds.find_by(id: params[:id])
  end

  def edit
    @post = Post.with_rich_text_content_and_embeds.find_by(id: params[:id])
    session[:blob] = []
  end

  def update
    @post = current_user.posts.find_by(id: params[:id])
    redirect_to @post if @post.update(post_params)
  end

  def destroy; end

  private

  attr_reader :post

  def post_params
    params.require(:post).permit(:title, :content, :user_id)
  end
end
