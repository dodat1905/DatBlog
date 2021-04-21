# frozen_string_literal: true

module ApplicationHelper
  def current_user
    User.find_by(id: cookies.signed[:user_id].presence || sessions[:user_id].presence)
  end
end
