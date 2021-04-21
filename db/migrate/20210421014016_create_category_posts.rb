class CreateCategoryPosts < ActiveRecord::Migration[6.1]
  def change
    create_table :category_posts do |t|
      t.references :posts
      t.references :categories

      t.timestamps
    end
  end
end
