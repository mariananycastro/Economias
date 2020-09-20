# frozen_string_literal: true

# Types of account, ex: Checking account, investiment, Credit card, Prepaid card
class AccountTypesController < ApplicationController
  def new
    @account_type = AccountType.new
    @account_types = account_types_ordered
  end

  def create
    @account_type = AccountType.new(params_type)
    return redirect_to root_path if @account_type.save

    render :new
  end

  def edit
    @account_type = account_type
    @account_types = account_types_ordered
  end

  def update
    @account_type = account_type
    return redirect_to root_path if @account_type.update(params_type)

    render :edit
  end

  def destroy
    @account_type = account_type
    return redirect_to root_path if @account_type.destroy

    render :new
  end

  private

  def account_types_ordered
    AccountType.all.order(:name)
  end

  def params_type
    params.require(:account_type).permit(:name)
  end

  def account_type
    AccountType.find(params[:id])
  end
end
