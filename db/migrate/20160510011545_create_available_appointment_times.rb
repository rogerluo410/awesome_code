class CreateAvailableAppointmentTimes < ActiveRecord::Migration[5.0]
  def change
    create_table :available_appointment_times do |t|
      t.time :start_time
      t.time :end_time
      t.belongs_to :user
      t.decimal :price
      t.string :week_name

      t.timestamps
    end
  end
end
