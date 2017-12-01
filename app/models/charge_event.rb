class ChargeEvent < ApplicationRecord
  extend Enumerize

  belongs_to :appointment
  has_many :charge_event_logs

  STATUS_HASH = {
    failed: 0,
    succeeded: 1,
    processing: 2,
  }

  enumerize :status, in: STATUS_HASH,
            scope: true,
            default: :failed,
            predicates: {prefix: true}

  def succeeded?
    status.succeeded?
  end

  def failed?
    status.failed?
  end

  def processing?
    status.processing?
  end
end
