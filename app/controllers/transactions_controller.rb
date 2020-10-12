# frozen_string_literal: true

# Class that creates transactions: income, expense
class TransactionsController < ApplicationController
  def edit
    @transaction = TransactionDecorator.new(transaction).decorate
    @accounts = ordered_accounts
    @categories = ordered_categories
    @transactions = transactions
  end

  def update
    @transaction = transaction
    if @transaction.transfer.nil?
      return redirect_to root_path if @transaction.update(params_transaction)
    end

    render :edit
  end

  def destroy
    @transaction = transaction

    return redirect_to root_path if delete_transaction

    render :edit
  end

  private

  def params_transaction
    params.require(:transaction)
          .permit(:name, :value, :date, :transaction_type, :account_id, :category_id)
  end

  def transactions
    TransactionDecorator.new(Transaction.all.order(:date)).decorate
  end

  def ordered_accounts
    Account.all.order(:name)
  end

  def ordered_categories
    Category.all.order(:name)
  end

  def transaction
    Transaction.find(params[:id])
  end

  def transaction_transfer
    transaction.transfer
  end

  def delete_transaction
    @transaction.destroy if transaction_transfer.nil?
  end
end
