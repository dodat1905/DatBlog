# frozen_string_literal: true

class CreateCategoryPosts < ActiveRecord::Migration[6.1]
  def change
    create_table :category_posts do |t|
      t.references :post
      t.references :category

      t.timestamps
    end
  end
end
