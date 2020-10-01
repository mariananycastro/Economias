class AddDefaultToAccountInitialValueAndActive < ActiveRecord::Migration[6.0]
  def change
    change_column :accounts, :initial_value, :numeric, default: 0
    change_column :accounts, :active, :boolean, default: true
  end
end
