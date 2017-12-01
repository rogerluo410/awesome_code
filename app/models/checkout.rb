class Checkout < ApplicationRecord
  attr_accessor :number, :cvc

  belongs_to :patient, foreign_key: :user_id

  scope :defaults, -> { where(default: true) }
end
