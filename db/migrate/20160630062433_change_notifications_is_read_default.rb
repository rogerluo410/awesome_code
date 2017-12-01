class ChangeNotificationsIsReadDefault < ActiveRecord::Migration[5.0]
  def change
    change_column_default :notifications, :is_read, false
  end
end
