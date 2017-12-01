class CreatePrescriptions < ActiveRecord::Migration[5.0]
  def change
    create_table :prescriptions do |t|
      t.references  :appointment, index: true
      t.references  :pharmacy, index: true
      t.string :file
      t.integer :status
      t.timestamps
    end
  end
end
