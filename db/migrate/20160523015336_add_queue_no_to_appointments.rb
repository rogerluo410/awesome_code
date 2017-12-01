class AddQueueNoToAppointments < ActiveRecord::Migration[5.0]
  def change
    add_column :appointments, :queue_no, :integer
    add_column :appointments, :appointment_date, :string
  end
end
