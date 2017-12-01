class CreatePharmacies < ActiveRecord::Migration[5.0]
  def change
    create_table :pharmacies do |t|
      t.string :category
      t.string :company_name
      t.string :street
      t.string :suburb
      t.string :state
      t.integer :code
      t.string :country
      t.string :phone
      t.string :website
      t.string :mobile
      t.string :toll_free
      t.string :fax
      t.string :abn
      t.string :postal_address
      t.string :email
      t.string :latitude
      t.string :longitude
      t.timestamps
    end
  end
end
