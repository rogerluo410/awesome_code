class CreateAuthTokens < ActiveRecord::Migration[5.0]
  def change
    enable_extension 'uuid-ossp'

    create_table :auth_tokens, id: :uuid do |t|
      t.belongs_to :user, index: true
      t.timestamps
    end
  end
end
