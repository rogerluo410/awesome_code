class RenameTimeZoneToUser < ActiveRecord::Migration[5.0]
  def change
    rename_column :users, :time_zone, :local_timezone
  end
end
