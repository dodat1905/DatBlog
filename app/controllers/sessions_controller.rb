# frozen_string_literal: true

class SessionsController < ApplicationController
  def index
    if current_user
      redirect_to root_path
      flash[:danger] = 'You are already logged in'
    end
  end

  def create
    @user = User.find_by(name: params[:name])
    if user && user.authenticate(params[:password])
      params[:remember_me] == 'true' ? cookies.signed[:user_id] = user.id : session[:user_id] = user.id
      redirect_to root_path
      flash[:success] = 'Login user successful'
    else
      flash.now[:danger] = 'User registration is unsuccessful. Username or password is wrong'
      render :index
    end
  end

  def destroy
    session.delete(:user_id)
    cookies.delete(:user_id)
    redirect_to root_path
    flash[:success] = 'Successfully logged out'
  end

  private

  attr_reader :user
end
