class AddQtdIntevalInitialDateToInstallments < ActiveRecord::Migration[6.0]
  def change
    add_column :installments, :qtd, :integer 
    add_column :installments, :interval, :integer 
    add_column :installments, :initial_date, :date 
  end
end
