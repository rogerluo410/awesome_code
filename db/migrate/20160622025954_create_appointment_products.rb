class CreateAppointmentProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :appointment_products do |t|
      t.datetime :start_time
      t.datetime :end_time
      t.belongs_to :appointment_setting, foreign_key: true
      t.integer :doctor_id, index: true
      t.timestamps
    end
  end
end
