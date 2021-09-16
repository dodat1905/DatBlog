# frozen_string_literal: true

class OmniauthController < Api::V1::ApiController
  def index
    redirect_to api_v1_posts_path
  end

  def google
    find_or_create_user
    token = JsonWebToken.encode(user_id: user.id)
    hours = 168.hours.from_now.in_time_zone.to_i
    refresh_token = JsonWebToken.encode(user_id: user.id, exp: hours)
    # render json: { message: 'Login user successfully!', token: token, refresh_token: refresh_token }, status: :ok
    redirect_to "http://localhost:8080?token=#{token}&refresh_token=#{refresh_token}&user=#{ActiveModelSerializers::SerializableResource.new(@user).to_json}"
  end

  def facebook; end

  private

  attr_reader :user

  def auth
    request.env['omniauth.auth']
  end

  def find_or_create_user
    @user = User.find_or_create_by(email: auth[:info][:email])
    user.name = auth[:info][:name]
    password = SecureRandom.hex(10)
    user.password = password
    user.password_confirmation = password
    user.save
  end
end
