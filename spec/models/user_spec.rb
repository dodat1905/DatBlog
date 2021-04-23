# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'association' do
    it { is_expected.to have_many(:posts) }
  end

  describe 'validation' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:password) }
  end

  describe '#remember' do
    let(:user) { FactoryBot.create(:user) }

    it 'update remember_digest' do
      user.remember
      expect(user.remember_digest).not_to be(nil)
    end
  end

  describe '#send_token_to_email' do
    let(:user) { FactoryBot.create(:user) }

    it 'update reset_digest' do
      user.send_token_to_email
      expect(user.reset_digest).not_to be(nil)
    end
  end
end
