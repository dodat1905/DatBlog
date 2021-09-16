# frozen_string_literal: true

class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :name, :type, :created_at, :updated_at

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
