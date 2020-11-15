class ChangeSimpleMovementToMovement < ActiveRecord::Migration[6.0]
  def change
    remove_reference :simple_movements, :transfer, foreign_key: true
    rename_table :simple_movements, :movements
  end
end
