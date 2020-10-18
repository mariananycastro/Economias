class ChangeNameTransaction < ActiveRecord::Migration[6.0]
  def change
    rename_table :transactions, :simple_movements
  end
end
