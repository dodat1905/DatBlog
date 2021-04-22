# frozen_string_literal: true

module ApplicationHelper
  def current_user
    if cookies.signed[:user_id].present?
      user = User.find_by(id: cookies.signed[:user_id])
      return user if BCrypt::Password.new(User.first.remember_digest) == cookies.signed[:remember_token].presence
    elsif session[:user_id].present?
      User.find_by(id: session[:user_id])
    end
  end
end
