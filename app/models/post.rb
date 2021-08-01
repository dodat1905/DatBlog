# frozen_string_literal: true

class Post < ApplicationRecord
  # Associations
  has_many :tag_posts, dependent: :destroy
  has_many :tags, through: :tag_posts
  belongs_to :user

  # Valdiations
  validates :title, presence: true
  validates :content, presence: true
  validate :tag_posts_present

  # Nested attributes
  accepts_nested_attributes_for :tag_posts, allow_destroy: true

  private

  def tag_posts_present
    return errors.add(:base, 'You must choose a tag') if tag_posts.blank?
  end
end
