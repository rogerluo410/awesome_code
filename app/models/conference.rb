class Conference < ApplicationRecord
  extend Enumerize

  belongs_to :appointment

  STATUS_HASH = {
      failed: 1, cancelled_by_doctor: 2, cancelled_by_patient: 3, timeout: 4, success: 5
  }

  enumerize :status, in: STATUS_HASH,
            scope: true,
            default: :success
end
