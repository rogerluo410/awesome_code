class CreateCheckouts < ActiveRecord::Migration[5.0]
  def change
    create_table :checkouts do |t|
      t.belongs_to :user, foreign_key: true
      t.string :address
      t.string :country
      t.string :email
      t.string :stripe_customer_id, limit: 50
      t.string :card_last4, limit:4
      t.string :brand, limit: 20
      t.boolean :default, default: false
      t.string :funding, limit: 10
      t.integer :exp_month
      t.integer :exp_year

      t.timestamps
    end
  end
end
