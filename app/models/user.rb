# frozen_string_literal: true

class User < ApplicationRecord
  has_many :posts, dependent: :destroy

  validates :name, presence: true
  validates :name, length: { minimum: 1 }
  validates :email, presence: true
  validates :password_confirmation, presence: true

  has_secure_password
end
