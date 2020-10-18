# frozen_string_literal: true

# account that holds all movements
class AccountsController < ApplicationController
  def new
    @account = AccountDecorator.new(Account.new).decorate
    @account_types = ordered_account_types
    @accounts = accounts
  end

  def create
    @account = AccountDecorator.new(Account.new(params_account)).decorate

    return redirect_to root_path if @account.save

    render :new
  end

  def edit
    @account = AccountDecorator.new(account).decorate
    @account_types = ordered_account_types
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

  def ordered_account_types
    AccountType.all.order(:name)
  end
end
