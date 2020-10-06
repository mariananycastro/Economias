# frozen_string_literal: true

# Class that creates transactions: debit, credit
class TransactionsController < ApplicationController
  def new
    @transaction = TransactionDecorator.new(Transaction.new).decorate
    @accounts = ordered_accounts
    @categories = ordered_categories
    @transactions = transactions
  end

  def create
    @transaction = TransactionDecorator.new(Transaction.new(params_transaction)).decorate

    return redirect_to root_path if @transaction.save

    render :new
  end

  def edit
    @transaction = TransactionDecorator.new(transaction).decorate
    @accounts = ordered_accounts
    @categories = ordered_categories
    @transactions = transactions
  end

  def update
    @transaction = transaction

    return redirect_to root_path if @transaction.update(params_transaction)

    render :new
  end

  def destroy
    @transaction = transaction

    return redirect_to root_path if @transaction.destroy

    render :edit
  end

  private

  def params_transaction
    params.require(:transaction)
      .permit(:name, :value, :date, :transaction_type, :account_id, :category_id )
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
end
