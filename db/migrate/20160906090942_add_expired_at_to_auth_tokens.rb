class AddExpiredAtToAuthTokens < ActiveRecord::Migration[5.0]
  def change
    add_column(:auth_tokens, :expired_at, :datetime)
  end
end
