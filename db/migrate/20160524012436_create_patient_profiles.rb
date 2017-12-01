class CreatePatientProfiles < ActiveRecord::Migration[5.0]
  def change
    create_table :patient_profiles do |t|
      t.integer :sex, default: 0
      t.date :birthday
      t.belongs_to :user, foreign_key: true

      t.timestamps
    end
  end
end
