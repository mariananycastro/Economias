class ChangeNamesTransactionType < ActiveRecord::Migration[6.0]
  def change
    rename_column :simple_movements, :transaction_type, :simple_movement_type
  end
end