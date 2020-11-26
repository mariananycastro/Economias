class ChangeAccountInitialValueToInteger < ActiveRecord::Migration[6.0]
  def change
    rename_column :accounts, :initial_value, :integer
  end
end
