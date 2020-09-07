class CreateAccountType < ActiveRecord::Migration[6.0]
  def change
    create_table :account_types do |t|
      t.string :name
    end
  end
end
