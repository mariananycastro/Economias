class CreateTransfers < ActiveRecord::Migration[6.0]
  def change
    create_table :transfers do |t|

    t.timestamps
    end
  end
end