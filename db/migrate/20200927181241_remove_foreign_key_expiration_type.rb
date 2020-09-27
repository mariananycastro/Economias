class RemoveForeignKeyExpirationType < ActiveRecord::Migration[6.0]
  def change 
    remove_reference :accounts, :expiration_type, foreign_key: true
  end
end
