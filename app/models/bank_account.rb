class BankAccount < ApplicationRecord
  belongs_to :doctor, class_name: 'User', foreign_key: :user_id

  scope :defaults, -> {
    where(default: true)
  }

end
