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

  def edit
    @account = account
    @account_types = AccountType.all
    @accounts = accounts
  end

  def update
    @account = account

    return redirect_to root_path if @account.update(params_account)

    render :edit
  end

  def destroy
    @account = account
    return redirect_to root_path if @account.destroy

    render :new
  end

  private

  def accounts
    AccountDecorator.new(Account.all.order(:name)).decorate
  end

  def params_account
    params.require(:account)
      .permit(:name,
              :active,
              :initial_value, 
              :account_type_id,
              :expiration_type)
  end

  def account
    Account.find(params[:id])
  end
end
