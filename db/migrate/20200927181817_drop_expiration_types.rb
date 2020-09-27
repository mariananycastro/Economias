class DropExpirationTypes < ActiveRecord::Migration[6.0]
  def change
    drop_table :expiration_types
  end
end
