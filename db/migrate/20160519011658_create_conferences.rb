class CreateConferences < ActiveRecord::Migration[5.0]
  def change
    create_table :conferences do |t|
      t.belongs_to :appointment, foreign_key: true
      t.integer :status, default: 1
      t.datetime :start_time
      t.datetime :end_time
      t.string :twillo_id

      t.timestamps
    end
  end
end
