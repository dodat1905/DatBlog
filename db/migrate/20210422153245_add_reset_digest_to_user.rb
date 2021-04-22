# frozen_string_literal: true

class AddResetDigestToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :reset_digest, :string
  end
end
