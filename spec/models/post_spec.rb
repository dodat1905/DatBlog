require 'rails_helper'

RSpec.describe Post, type: :model do
  describe "association" do
    it { is_expected.to have_many(:category_posts) }
    it { is_expected.to have_many(:categories) }
  end

  describe "validation" do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:content) }
  end
end
