class AddUnreadToNotification < ActiveRecord::Migration[6.1]
  def change
    add_column :notifications, :unread, :boolean, default: false
  end
end
