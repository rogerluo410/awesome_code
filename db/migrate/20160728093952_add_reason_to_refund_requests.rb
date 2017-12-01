class AddReasonToRefundRequests < ActiveRecord::Migration[5.0]
  def change
    add_column(:refund_requests, :reason, :string)
  end
end
