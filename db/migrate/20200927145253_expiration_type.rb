class ExpirationType < ActiveRecord::Migration[6.0]
  def change
    create_table :expiration_types do |t|
      t.integer :period, default: 0
    end
  end
end
