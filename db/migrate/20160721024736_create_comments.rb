class CreateComments < ActiveRecord::Migration[5.0]
  def change
    create_table :comments do |t|
      t.belongs_to :appointment, foreign_key: true
      t.integer :receiver_id
      t.integer :sender_id
      t.text :body

      t.timestamps
    end
  end
end
