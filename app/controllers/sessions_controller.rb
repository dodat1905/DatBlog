# frozen_string_literal: true

class SessionsController < ApplicationController
  before_action :find_user, only: [:create]

  def index
    return unless current_user

    redirect_to root_path
    flash[:danger] = 'You are already logged in'
  end

  def create
    @user = User.find_by(name: params[:name])
    if user&.authenticate(params[:password])
      remember_user
      redirect_to root_path
      flash[:success] = 'Login user successful'
    else
      flash.now[:danger] = 'User registration is unsuccessful. Username or password is wrong'
      render :index
    end
  end

  def edit
    return redirect_to root_path if current_user

    @user = User.find_by(email: params[:email])
    return redirect_to root_path if user && ((Time.current.in_time_zone - user.reset_password_at) / 3600 > 1)

    @token = params[:token]
    @has_token = BCrypt::Password.new(user.reset_digest) == params[:token] if user&.reset_digest
  end

  def update
    @user = User.find_by(email: params.dig(:user, :token) ? user_params[:email] : params[:email])
    if user&.reset_digest && BCrypt::Password.new(user.reset_digest) == params.dig(:user, :token)
      update_new_password
    else
      send_token
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

  def remember_user
    if params[:remember_me] == 'true'
      user.remember
      cookies.signed[:remember_token] = { value: user.remember_token, expires: Time.zone.now + 168.hours }
      cookies.signed[:user_id] = { value: user.id, expires: Time.zone.now + 168.hours }
    else
      session[:user_id] = user.id
    end
  end

  def find_user
    @user = User.find_by(name: params[:name])
    return if user

    redirect_to root_path
    flash[:danger] = 'User not found'
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :reset_digest)
  end

  def update_new_password
    if user.update(password: user_params[:password], password_confirmation: user_params[:password_confirmation])
      user.update(reset_digest: nil, reset_password_at: nil)
      flash[:success] = 'Reset password successfully'
      redirect_to root_path
    else
      @has_token = BCrypt::Password.new(user.reset_digest) == params.dig(:user, :token)
      @token = params.dig(:user, :token)
      flash[:danger] = 'There was an error in editing the user'
      render :edit
    end
  end

  def send_token
    user.send_token_to_email
    UserMailer.with(email: params[:email], token: user.reset_token).reset_password.deliver_now
    flash[:success] = 'Password reset link has been sent to your email'
    redirect_to root_path
  end
end
