# frozen_string_literal: true

class NotificationSerializer < ActiveModel::Serializer
  attributes :id, :sender, :sender_id, :body, :created_at, :receiver_id, :receiver, :unread

  def sender
    object.sender.name
  end

  def created_at
    object.created_at.strftime('%Y-%m-%d %H:%M')
  end

  def receiver
    object.receiver&.name
  end
end
