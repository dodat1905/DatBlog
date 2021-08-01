# frozen_string_literal: true

class TagPost < ApplicationRecord
  belongs_to :post
  belongs_to :category
end
