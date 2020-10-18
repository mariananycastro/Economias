class CreateInstallmentSimpleMovements < ActiveRecord::Migration[6.0]
  def change
    create_table :installment_simple_movements do |t|
      t.references :installment, null: false, foreign_key: true
      t.references :simple_movement, null: false, foreign_key: true
    end
  end
end
