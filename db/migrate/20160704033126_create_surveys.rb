class CreateSurveys < ActiveRecord::Migration[5.0]
  def change
    create_table :surveys do |t|
      t.belongs_to :user, foreign_key: true
      t.belongs_to :appointment, foreign_key: true
      t.string :full_name
      t.string :suburb
      t.integer :age
      t.integer :gender, default: 0
      t.string :street_address
      t.integer :weight
      t.integer :height
      t.string :occupation
      t.text :medical_condition
      t.text :medications
      t.string :reason
      t.string :allergies

      t.timestamps
    end
  end
end
