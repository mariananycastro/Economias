class AddColumnExpirationTypeToAccount < ActiveRecord::Migration[6.0]
  def change
    add_column :accounts, :expiration_type, :integer, default: 0
  end
end
