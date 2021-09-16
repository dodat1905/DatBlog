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

  # Active storage
  has_many_attached :images

  # Elasticsearch
  def can_quote?(booking)
    return false unless active? || artist?
    return true if booking.direct?

    state = false
    booking_speciality_ids = booking.booking_art_types.map(&:speciality_ids).flatten
    booking_genre_ids = booking.booking_art_types.map(&:genre_ids).flatten

    if (country_id == booking.country_id) && booking.art_type_ids.include?(art_type_id) &&
       event_type_ids.include?(booking.event_type_id)
      state = true
      state = (speciality_ids & booking_speciality_ids).any? if booking_speciality_ids.present?
      state = (booking_genre_ids & genre_ids).any? if booking_genre_ids.present?
    end
    state
  end

  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  settings do
    mappings dynamic: false do
      indexes :title, type: :text, analyzer: :english
      indexes :content, type: :text, analyzer: :english
      indexes :published, type: :boolean
    end
  end

  def self.search(query)
    __elasticsearch__.search(
      {
        size: 300,
        query: {
          bool: {
            must: {
              multi_match: {
                query: query,
                fields: %i[title content]
              },
            },
            filter: {
              term: {
                published: true
              }
            }
          },
        }
      }
    )
  end
  # index_name Rails.application.parent_name.downcase
  # document_type self.name.downcase

  # def self.search(query)

  # end

  private

  def tag_posts_present
    return errors.add(:base, 'You must choose a tag') if tag_posts.blank?
  end
end
