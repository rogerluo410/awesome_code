class CreateDoctorProfiles < ActiveRecord::Migration[5.0]
  def change
    create_table :doctor_profiles do |t|
      t.belongs_to :user, foreign_key: true
      t.string :phone_number, limit: 30
      t.decimal :years_experience
      t.text :bio_info
      t.boolean :approved, default: false
      t.boolean :available, default: false
      t.string :provider_number
      t.integer :specialty_id
      t.timestamps
    end
  end
end
