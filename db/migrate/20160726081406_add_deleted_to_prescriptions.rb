class AddDeletedToPrescriptions < ActiveRecord::Migration[5.0]
  def change
    add_column :prescriptions, :deleted, :boolean, default: false
  end
end
