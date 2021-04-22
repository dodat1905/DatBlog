# frozen_string_literal: true

class AddResetTimetToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :reset_password_at, :datetime
  end
end
