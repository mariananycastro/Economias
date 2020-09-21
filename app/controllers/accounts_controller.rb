# frozen_string_literal true

# account that holds all transactions
class AccountsController < ApplicationController
  def new
    @account = Account.new
    @account_type = AccountType.all
    @accounts = accounts
  end

  def create
    binding.pry
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
              :status,
              :initial_value, 
              :account_type_id)
  end

  # def initial_value_default
  #   params.require(:account).permit(:initial_value) ||= 0
  # end
# https://stackoverflow.com/questions/44870389/sort-objects-in-array-by-2-attributes-in-ruby-with-the-spaceship-operator
  # def <=>(other)
  #   [str.size, str] <=> [other.str.size, other.str]
  # end
end
