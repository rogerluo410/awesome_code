class CreateTransferEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :transfer_events do |t|
      t.belongs_to :appointment, foreign_key: true
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
