class CreateAddresses < ActiveRecord::Migration[5.0]
  def change
    create_table :addresses do |t|
      t.belongs_to :user, foreign_key: true
      t.string :country
      t.string :postcode, limit: 10
      t.string :state
      t.string :suburb
      t.string :street_address
      t.decimal :latitude
      t.decimal :longitude
      t.timestamps
    end
  end
end
