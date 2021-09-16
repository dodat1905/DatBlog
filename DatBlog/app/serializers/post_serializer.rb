# frozen_string_literal: true

class PostSerializer < ActiveModel::Serializer
  attributes :id, :title, :content, :created_at, :tags, :author

  def created_at
    object.created_at.strftime('%Y-%m-%d %H:%M')
  end

  def tags
    object.tags.pluck(:name)
  end

  def author
    object.user.name
  end
end
