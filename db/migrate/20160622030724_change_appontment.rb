class ChangeAppontment < ActiveRecord::Migration[5.0]
  def change
    add_column :appointments, :appointment_product_id, :integer, index: true
    remove_column :appointments, :appointment_setting_id
    remove_column :appointments, :appointment_date
    remove_column :appointments, :queue_no
    remove_column :appointments, :may_started_at
  end
end
