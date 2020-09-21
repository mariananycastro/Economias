class RenameStatusToActiveInAccount < ActiveRecord::Migration[6.0]
  def change
    rename_column :accounts, :status, :active
  end
end
