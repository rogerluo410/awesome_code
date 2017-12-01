class Address < ApplicationRecord
  belongs_to :user

  validates :postcode, length: { maximum: 10 }
end
