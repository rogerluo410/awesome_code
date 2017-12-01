class DoctorProfile < ApplicationRecord
  include ReferenceUpdatable

  validates :years_experience, numericality: true, allow_nil: true

  belongs_to :doctor, class_name: 'User', foreign_key: :user_id
  belongs_to :specialty

  delegate :name, to: :specialty, prefix: true, allow_nil: true
end
