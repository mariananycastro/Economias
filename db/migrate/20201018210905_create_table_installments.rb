class CreateTableInstallments < ActiveRecord::Migration[6.0]
  def change
    create_table :installments do |t|
        t.timestamps
    end
  end
end
