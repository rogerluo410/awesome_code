class CreateRefundRequests < ActiveRecord::Migration[5.0]
  def change
    create_table :refund_requests do |t|
      t.belongs_to :appointment, foreign_key: true
      t.integer :status, default: 0
      t.belongs_to :charge_event_log, foreign_key: true
      t.belongs_to :transfer_event_log, foreign_key: true
      t.timestamps
    end
  end
end
