class CreateAppointments < ActiveRecord::Migration[5.0]
  def change
    create_table :appointments do |t|
      t.integer :doctor_id, index: true
      t.integer :patient_id, index: true
      t.belongs_to :available_appointment_time, foreign_key: true
      t.integer :status, default: 1
      t.datetime :may_started_at

      t.timestamps
    end
  end
end
