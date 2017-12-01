class CreateBankAccounts < ActiveRecord::Migration[5.0]
  def change
    create_table :bank_accounts do |t|
      t.belongs_to :user, foreign_key: true
      t.string :account_id
      t.string :country, limit:10
      t.string :currency, limit:10, default: "aud"
      t.string :account_holder_name
      t.string :account_holder_type
      t.string :bank_name
      t.string :last4, limit:4
      t.string :routing_number

      t.timestamps
    end
  end
end
