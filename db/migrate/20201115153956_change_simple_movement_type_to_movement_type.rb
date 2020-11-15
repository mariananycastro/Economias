class ChangeSimpleMovementTypeToMovementType < ActiveRecord::Migration[6.0]
  def change
    rename_column :movements, :simple_movement_type, :movement_type
  end
end
