class CreateChargeEventLogs < ActiveRecord::Migration[5.0]
  def change
    create_table :charge_event_logs do |t|
      t.string :stripe_customer_id
      t.decimal :amount
      t.string :currency
      t.string :card_last4
      t.string :card_brand
      t.string :stripe_charge_id
      t.integer :status
      t.integer :checkout_id
      t.integer :appointment_id

      t.timestamps
    end
  end
end
