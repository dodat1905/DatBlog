require 'rails_helper'

RSpec.describe CategoryPost, type: :model do
  describe "association" do
    it { is_expected.to belongs_to(:post)) }
    it { is_expected.to belongs_to(:category)) }
  end
end
