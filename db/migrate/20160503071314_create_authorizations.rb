class CreateAuthorizations < ActiveRecord::Migration[5.0]
  def change
    create_table :authorizations do |t|
      t.belongs_to :user, foreign_key: true
      t.string :provider
      t.string :uid
      t.string :token
      t.string :secret
      t.string :username

      t.timestamps
    end
  end
end
