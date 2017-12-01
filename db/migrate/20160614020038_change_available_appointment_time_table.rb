class ChangeAvailableAppointmentTimeTable < ActiveRecord::Migration[5.0]
  def change
    rename_column :available_appointment_times, :week_name, :week_day
    change_column :available_appointment_times, :start_time, :string, limit: 10
    change_column :available_appointment_times, :end_time, :string, limit: 10
    rename_table :available_appointment_times, :appointment_settings
    rename_column :appointments, :available_appointment_time_id, :appointment_setting_id
  end
end
