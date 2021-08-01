# frozen_string_literal: true

class Tag < ApplicationRecord
  # Assosications
  has_many :tag_posts, dependent: :destroy
  has_many :posts, through: :tag_posts

  # Validations
  validates :name, presence: true
end
