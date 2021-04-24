# frozen_string_literal: true

class Post < ApplicationRecord
  # Associations
  has_many :category_posts, dependent: :destroy
  has_many :categories, through: :category_posts
  belongs_to :user

  # Valdiations
  validates :title, presence: true
  validates :content, presence: true

  # Active storage
  has_rich_text :content
end
