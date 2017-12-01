class ChangeEventLogs < ActiveRecord::Migration[5.0]
  def change
  	rename_column :transfer_event_logs, :appointment_id, :transfer_event_id
  	rename_column :charge_event_logs, :appointment_id, :charge_event_id
  end
end

