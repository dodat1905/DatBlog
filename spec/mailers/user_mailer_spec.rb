# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserMailer, type: :mailer do
  describe 'reset_password' do
    let(:user) { FactoryBot.create(:user) }
    let(:mailer) { described_class.with(email: user.email, token: user.reset_token).reset_password }

    before do
      user.send_token_to_email
    end

    it 'renders the subject' do
      expect(mailer.subject).to eql("Reset password at Dat's Blog")
    end

    it 'renders the receiver email' do
      expect(mailer.to).to eql([user.email])
    end

    it 'assigns @confirmation_url' do
      expect(mailer.body.encoded).to include("token=#{user.reset_token}")
    end
  end
end
