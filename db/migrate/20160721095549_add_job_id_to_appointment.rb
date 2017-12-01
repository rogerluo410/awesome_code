class AddJobIdToAppointment < ActiveRecord::Migration[5.0]
  def change
  	add_column :appointments, :job_id, :string
  end
end
