# frozen_string_literal true

# account that holds all transactions
class AccountsController < ApplicationController
  def new
    @account = Account.new
    @account_types = AccountType.all
    @accounts = accounts
  end

  def create
    @account = Account.new(params_account)

    return redirect_to root_path if @account.save

    render :new
  end

  private

  def accounts
    Account.all
  end

  def params_account
    params.require(:account)
      .permit(:name,
              :active,
              :initial_value, 
              :account_type_id,
              :expiration_type)
  end
end
