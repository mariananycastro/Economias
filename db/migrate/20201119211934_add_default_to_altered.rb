class AddDefaultToAltered < ActiveRecord::Migration[6.0]
  def change
    change_column :installment_movements, :altered, :boolean, default: false
  end
end
