class RenameChangedToAltered < ActiveRecord::Migration[6.0]
  def change
    rename_column :installment_movements, :changed, :altered
  end
end
