# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CategoryPost, type: :model do
  describe 'association' do
    it { is_expected.to belong_to(:post) }
    it { is_expected.to belong_to(:category) }
  end
end
