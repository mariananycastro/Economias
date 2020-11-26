class MonetizeAccount < ActiveRecord::Migration[6.0]
  def change
    change_table :accounts do |t|
      t.money :initial_value, amount: { null: true, default: 0.00 } 
      t.monetize :initial_value
    end
  end
end
