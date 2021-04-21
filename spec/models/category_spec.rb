# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Category, type: :model do
  describe 'association' do
    it { is_expected.to have_many(:category_posts) }
    it { is_expected.to have_many(:posts) }
  end

  describe 'validation' do
    it { is_expected.to validate_presence_of(:name) }
  end
end