class Change < ActiveRecord::Migration[6.0]
  def change
    rename_column :installment_simple_movements, :simple_movement_id, :movement_id
    rename_table :installment_simple_movements, :installment_movements
  end
end
