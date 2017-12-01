class CreateDevices < ActiveRecord::Migration[5.0]
  def change
    create_table :devices do |t|
      t.integer :platform
      t.string :token
      t.belongs_to :user, foreign_key: true

      t.timestamps
    end
    add_index :devices, [:platform, :token], unique: true
  end
end
