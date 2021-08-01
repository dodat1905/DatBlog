# frozen_string_literal: true

class User < ApplicationRecord
  # Associations
  has_many :posts, dependent: :destroy

  # Valdiations
  validates :name, presence: true, uniqueness: true, length: { maximum: 50 }
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password_confirmation, presence: true, if: :password_presence?

  # Password
  has_secure_password
  has_secure_password :reset, validations: false

  private

  def password_presence?
    password.present?
  end
end
