# frozen_string_literal: true

# Class that creates transfer with 2 transactions (income and expense)
class TransfersController < ApplicationController
  def edit
    @transfer = transfer

    @accounts = ordered_accounts
    @categories = ordered_categories

    @transactions = TransactionDecorator.new(transactions).decorate
  end

  def update
    @transfer = transfer
    @params = params

    return redirect_to root_path if ActiveRecord::Base.transaction do
      origin = Transaction.find(params[:transfer][:origin_attributes][:id])
      destiny = Transaction.find(params[:transfer][:destiny_attributes][:id])

      origin.update!(params_origin)
      destiny.update!(params_destiny)
      @transfer.origin = origin
      @transfer.destiny = destiny
      @transfer.save
    end

    render :edit
  end

  def destroy
    return redirect_to root_path if transfer.destroy

    render :edit
  end

  private

  def transfer
    Transfer.find(params[:id])
  end

  def ordered_accounts
    Account.all.order(:name)
  end

  def ordered_categories
    Category.all.order(:name)
  end

  def transactions
    Transaction.all.order(:date)
  end

  def params_transaction
    @params.require(:transfer)
           .permit({ origin_attributes: %i[name value date category_id] })
           .dig(:origin_attributes)
  end

  def params_origin
    params_transaction.merge!(
      {
        account_id: @params[:transfer][:origin_attributes][:origin_id],
        transaction_type: 'expense'
      }
    )
  end

  def params_destiny
    params_transaction.merge!(
      {
        account_id: @params[:transfer][:destiny_attributes][:destiny_id],
        transaction_type: 'income'
      }
    )
  end
end
