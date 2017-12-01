class AddSubscribeWayToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :notify_sms, :boolean, default: true
    add_column :users, :notify_email, :boolean, default: true
    add_column :users, :notify_system, :boolean, default: true
  end
end
