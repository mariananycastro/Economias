class AddReferenceToTransaction < ActiveRecord::Migration[6.0]
  def change
    add_reference :transactions, :transfer, foreign_key: true
  end
end
