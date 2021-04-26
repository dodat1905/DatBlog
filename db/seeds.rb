# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

if User.find_by(name: 'dodat1905').blank?
  User.create(name: 'dodat1905', email: 'dodat1905@gmail.com', password: '123456', password_confirmation: '123456')
end
if Category.all.blank?
  categories = ['Travel', 'Excursion', 'Voyage', 'Adventure', 'Wander', 'Wanderlust', 'Nomad', 'Trip', 'Trek', 'Globe',
                'Tour', 'Navigate', 'Search', 'Find', 'Discover', 'Journey', 'Drift', 'Lifestyle', 'Fashion', 'Style',
                'Way of life', 'Growth', 'Trend', 'Craze', 'Health', 'Chic', 'Food', 'Eat', 'Taste', 'Cook',
                'Nutrition', 'Cuisine', 'Meal', 'Drink', 'Recipe', 'Creative', 'DIY', 'Interior Design', 'Art', 'Craft',
                'Design', 'Notes', 'Photography', 'Homemade', 'Handmade', 'Picture', 'Frame', 'Illustration', 'Drawing',
                'Graphic', 'Fabric', 'Woodwork', 'Paper', 'Poetry', 'Personal', 'Value', 'Inspire', 'Writing', 'Dreams',
                'Passion', 'Beauty', 'Make-up', 'Fashion', 'Love', 'Allure', 'Gloss', 'Model']
  categories.each do |category|
    Category.create(name: category)
  end
end
