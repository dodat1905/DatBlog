# frozen_string_literal: true

class Category < ApplicationRecord
  # Assosications
  has_many :category_posts, dependent: :destroy
  has_many :posts, through: :category_posts

  # Validations
  validates :name, presence: true
end
