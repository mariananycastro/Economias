class AddChangedToInstallmentMovements < ActiveRecord::Migration[6.0]
  def change
    add_column :installment_movements, :changed, :boolean 
  end
end
