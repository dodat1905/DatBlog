class AddResetToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :reset_digest, :string
    add_column :posts, :reset_sent_at, :datetime
  end
end
