# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password_digest
      t.string :type
      t.string :remember_digest
      t.string :reset_digest
      t.datetime :reset_password_at

      t.timestamps
    end
  end
end
