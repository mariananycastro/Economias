class AddInitialDateToInstallments < ActiveRecord::Migration[6.0]
  def change
    add_column :installments, :initial_date, :date 
  end
end
