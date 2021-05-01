# frozen_string_literal: true

class UsersController < ApplicationController
  def index; end

  def new
    if current_user
      redirect_to root_path
      flash[:danger] = 'You are already logged in'
    else
      @user = User.new
    end
  end

  def create
    @user = User.new(user_params)
    if user.save
      redirect_to root_path
      flash[:success] = 'User registration is successful'
    else
      flash.now[:danger] = 'There was an error in registering the user'
      render :new
    end
  end

  def edit
    if current_user.blank?
      redirect_to sessions_path
      flash[:danger] = 'You are not logged in'
    else
      @user = User.find_by(id: params[:id])
      redirect_to sessions_path unless current_user.id == user.id
    end
  end

  def update
    @user = User.find_by(id: params[:id])
    if user.update(user_params)
      request_successfully
    else
      request_unsuccessfully
    end
  end

  private

  attr_reader :user

  def request_successfully
    if request.format.json?
      render json: {
        success: 'Upload avatar successfully'
      }
    else
      redirect_to edit_user_path(user)
      flash[:success] = 'Update user is successful'
    end
  end

  def request_unsuccessfully
    if request.format.json?
      render json: {
        error: 'Upload avatar has an error'
      }
    else
      flash.now[:danger] = 'There was an error in editing the user'
      render :edit
    end
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :avatar)
  end
end
