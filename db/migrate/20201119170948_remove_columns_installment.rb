class RemoveColumnsInstallment < ActiveRecord::Migration[6.0]
  def change
    remove_column :installments, :installment_qtd
    remove_column :installments, :installment_interval
    remove_column :installments, :initial_date
  end
end
