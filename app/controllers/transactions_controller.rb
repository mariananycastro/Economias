# frozen_string_literal: true

# Class that creates transactions: income, expense
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
    return redirect_to root_path if update_transaction

    render :new
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

  def update_transaction
    @transaction.update(params_transaction) if transaction_transfer.nil?
    
    update_transfer(params)
  end

  def update_transfer(params)
    params_update = params.require(:transaction)
                   .permit(:name, :value, :date, :account_id, :category_id)

    origin = transaction_transfer.origin
    destiny = transaction_transfer.destiny

    ActiveRecord::Base.transaction do
      if @transaction.transaction_type != params[:transaction][:transaction_type]
        transaction_transfer.origin = destiny
        transaction_transfer.destiny = origin
        transaction_transfer.save

        binding.pry
        transaction_transfer.origin.update(params_update.merge({ transaction_type: Transaction.transaction_types[:expense] }))
        transaction_transfer.destiny.update(params_update.merge({ transaction_type: Transaction.transaction_types[:income] }))
      else
        transaction_transfer.origin.update(params_update)
        transaction_transfer.destiny.update(params_update)
      end
    end
  end
  
  def transaction_transfer
    transaction.transfer
  end

  def delete_transaction
    @transaction.destroy if transaction_transfer.nil?

    delete_transfer
  end

  def delete_transfer
    ActiveRecord::Base.transaction do
      transaction_transfer.destroy
    end
  end
end
