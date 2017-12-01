class CreateNotifications < ActiveRecord::Migration[5.0]
  def change
    create_table :notifications do |t|
      t.string :n_type
      t.belongs_to :user, index: true, foreign_key: true
      t.integer :resource_id, index: true
      t.string :resource_type
      t.boolean :is_read
      t.text :body

      t.timestamps
    end
  end
end
