# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Post, type: :model do
  describe 'association' do
    it { is_expected.to have_many(:category_posts) }
    it { is_expected.to have_many(:categories) }
    it { is_expected.to belong_to(:user) }
  end

  describe 'validation' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:content) }
  end

  describe '#category_posts_present' do
    let(:user) { FactoryBot.create(:user) }
    let(:category) { FactoryBot.create(:category) }

    it 'update remember_digest' do
      post = user.posts.build(title: 'Post', content: 'ABC')
      post.valid?
      expect(post.errors[:base]).to include('You must choose a category')
    end
  end
end
