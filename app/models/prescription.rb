class Prescription < ApplicationRecord
  extend Enumerize

  mount_uploader :file, PrescriptionFileUploader

  belongs_to :appointment
  belongs_to :pharmacy

  validates :file, presence: true

  delegate :pharmacy_name, to: :pharmacy, allow_nil: true

  scope :not_deleted, -> { where(deleted: false) }

  STATUS_HASH = {
    pending: 1, delivering: 2, delivered: 3
  }

  enumerize :status, in: STATUS_HASH,
            scope: true,
            default: :pending,
            predicates: {prefix: true}
end
