class CreateTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :transactions do |t|
      t.string :name
      t.decimal :value
      t.date :date
      t.integer :type

      t.timestamps
    end
  end
end
