class ChargeEventLog < ApplicationRecord
  extend Enumerize

  belongs_to :charge_event
  belongs_to :checkout
  has_one :refund_request

  STATUS_HASH = {
    succeeded: 1,
    failed: 0
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
end
