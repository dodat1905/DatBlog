# frozen_string_literal: true

module PostsService
  class SendNotification
    def call(post)
      @notification = Notification.create(sender: post.user, body: 'A new post', unread: true)
      data = notification.as_json
      data['sender'] = notification.sender.name
      data['created_at'] = notification.created_at.strftime('%Y-%m-%d %H:%M')
      ActionCable.server.broadcast('notifications', data)
    end

    private

    attr_reader :notification
  end
end
