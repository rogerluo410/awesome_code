class CreateMedicalCertificates < ActiveRecord::Migration[5.0]
  def change
    create_table :medical_certificates do |t|
      t.belongs_to :appointment, foreign_key: true
      t.string :file
      t.boolean :deleted, default: false

      t.timestamps
    end
  end
end
