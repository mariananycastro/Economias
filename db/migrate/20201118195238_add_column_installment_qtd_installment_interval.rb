class AddColumnInstallmentQtdInstallmentInterval < ActiveRecord::Migration[6.0]
  def change
    add_column :installments, :installment_qtd, :integer 
    add_column :installments, :installment_interval, :integer 
  end
end
