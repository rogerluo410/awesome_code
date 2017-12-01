class TransferEventLog < ApplicationRecord
	extend Enumerize

  belongs_to :transfer_event
  has_one :refund_request

  STATUS_HASH = {
    paid: 1,
    failed: 0
  }

  enumerize :status, in: STATUS_HASH,
            scope: true,
            default: :failed,
            predicates: {prefix: true}

  def succeeded?
    status.paid?
  end

  def failed?
    status.failed?
  end
end
