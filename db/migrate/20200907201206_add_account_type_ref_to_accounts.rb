class AddAccountTypeRefToAccounts < ActiveRecord::Migration[6.0]
  def change
    add_reference :accounts, :account_type, foreign_key: true
  end
end
