class CreateTransferEventLogs < ActiveRecord::Migration[5.0]
  def change
    create_table :transfer_event_logs do |t|
      t.string :stripe_transfer_id
      t.integer :appointment_id
      t.string :currency
      t.decimal :amount
      t.integer :status
      t.string :destination
      t.text :error_message
      t.timestamps
    end
  end
end
