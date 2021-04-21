require 'rails_helper'

RSpec.describe User, type: :model do
  describe "association" do
    it { is_expected.to have_many(:posts) }
  end

  describe "validation" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:email) }
  end
end
