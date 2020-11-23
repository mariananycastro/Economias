class AddNameToInstallment < ActiveRecord::Migration[6.0]
  def change
    add_column :installments, :comum_name, :string 
  end
end
