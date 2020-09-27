class AddExpirationTypeRefToAccount < ActiveRecord::Migration[6.0]
  def change
    add_reference :accounts, :expiration_type, foreign_key: true
  end
end
