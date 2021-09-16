# frozen_string_literal: true

class User < ApplicationRecord
  # Associations
  has_many :posts, dependent: :destroy
  has_many :notifications, foreign_key: :receiver_id

  # Valdiations
  validates :name, presence: true, uniqueness: true, length: { maximum: 50 }
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password_confirmation, presence: true, if: :password_presence?
  validates :password, length: { minimum: 8 }, allow_blank: true
  validates :password_confirmation, length: { minimum: 8 }, allow_blank: true

  # Password
  has_secure_password
  has_secure_password :reset, validations: false

  class << self
    def digest(string)
      cost =
        if ActiveModel::SecurePassword.min_cost
          BCrypt::Engine::MIN_COST
        else
          BCrypt::Engine.cost
        end
      BCrypt::Password.create string, cost: cost
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def create_reset_digest(reset_token)
    update(reset_digest: User.digest(reset_token))
    update(reset_password_at: Time.current.in_time_zone)
  end

  def send_password_reset_email(reset_token)
    UserMailer.password_reset(self, reset_token).deliver_now
  end

  def admin?
    type == 'Admin'
  end

  private

  def password_presence?
    password.present?
  end
end
