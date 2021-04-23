# frozen_string_literal: true

class User < ApplicationRecord
  attr_accessor :remember_token, :reset_token

  has_many :posts, dependent: :destroy

  validates :name, presence: true
  validates :name, length: { maximum: 50 }
  validates :email, presence: true, uniqueness: true
  validates :password_confirmation, presence: true, if: :password_presence?

  has_secure_password
  has_secure_password :reset, validations: false

  def remember
    self.remember_token = SecureRandom.urlsafe_base64
    update(remember_digest: BCrypt::Password.create(remember_token))
  end

  def send_token_to_email
    self.reset_token = SecureRandom.urlsafe_base64
    update(reset_digest: BCrypt::Password.create(reset_token), reset_password_at: Time.current.in_time_zone)
  end

  private

  def password_presence?
    password.present?
  end
end
