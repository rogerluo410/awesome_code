class AddConsultationFeeToAppointment < ActiveRecord::Migration[5.0]
  def change
    add_column :appointments, :consultation_fee, :decimal
    add_column :appointments, :doctor_fee, :decimal
  end
end
