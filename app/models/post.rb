class Post < ApplicationRecord
  has_many :category_posts, dependent: :destroy
  has_many :categories, through: :category_posts
  belongs_to :user

  validates :title, presence: true
  validates :content, presence: true
end
