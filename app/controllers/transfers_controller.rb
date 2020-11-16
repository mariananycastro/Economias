# frozen_string_literal: true

# Class that creates transfer with 2 movement (income and expense)
class TransfersController < ApplicationController
  def new
    @transfer = Transfer.new

    @accounts = ordered_accounts
    @categories = ordered_categories
  end

  def create
    Movement::Transfer.create(params_origin, params_destiny)

    redirect_to root_path
  end

  def edit
    @transfer = Transfer.find(params[:id])
    origin_account = @transfer.origin
    destiny_account = @transfer.destiny

    @comum_params = origin_account
    @account_origin = origin_account.account
    @account_destiny = destiny_account.account

    @accounts = ordered_accounts
    @categories = ordered_categories
  end

  def update
    Movement::Transfer.update(params[:id], params_origin, params_destiny)

    redirect_to root_path
  end

  private

  def ordered_accounts
    Account.all.order(:name)
  end

  def ordered_categories
    Category.all.order(:name)
  end

  def params_transfer
    params.require(:comum_params)
          .permit(:name, :value, :date, :category_id)
  end

  def params_destiny
    params_transfer.merge(
      {
        account_id: params[:account_destiny][:id],
        movement_type: :income
      }
    )
  end

  def params_origin
    params_transfer.merge(
      {
        account_id: params[:account_origin][:id],
        movement_type: :expense
      }
    )
  end
end
