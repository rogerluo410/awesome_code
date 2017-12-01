class AddTimezoneToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :time_zone, :string, default: "Australia/Sydney"
  end
end
