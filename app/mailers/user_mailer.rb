# frozen_string_literal: true

class UserMailer < ApplicationMailer
  def reset_password
    @email = params[:email]
    @token = params[:token]
    mail(to: @email, subject: "Reset password at Dat's Blog")
  end
end
