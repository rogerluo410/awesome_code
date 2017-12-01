class AddUsernameToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :username, :string, limit: 30
  end
end
