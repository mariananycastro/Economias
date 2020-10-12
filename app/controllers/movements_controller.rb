# frozen_string_literal: true

# Class responsable for creating a transaction or a transfer with 2 transactions
class MovementsController < ApplicationController
  def new
    @movement = Movement.new

    @accounts = accounts
    @categories = categories

    @transactions = transactions
  end

  def create
    if !params[:movement][:account_id].nil?
      @transaction = Transaction.new(params_transaction)
      return redirect_to root_path if @transaction.save
    else
      return redirect_to root_path if ActiveRecord::Base.transaction do
        @income = Transaction.create!(params_income)
        @expense = Transaction.create!(params_expense)
        @transfer = Transfer.create!(origin_id: @expense.id, destiny_id: @income.id)
        @income.update!(transfer: @transfer)
        @expense.update!(transfer: @transfer)
      end
    end

    render :new
  end

  private

  def params_transaction
    params.require(:movement)
          .permit(:name, :value, :date, :category_id, :account_id, :transaction_type)
          .merge!(type)
  end

  def type
    return { transaction_type: 'income' } if params[:movement][:transaction_type] == '0'

    { transaction_type: 'expense' }
  end

  def params_transfer
    params.require(:movement)
          .permit(:name, :value, :date, :category_id)
  end

  def params_income
    params_transfer.merge(
      {
        account_id: params[:movement][:destiny_id],
        transaction_type: 'income'
      }
    )
  end

  def params_expense
    params_transfer.merge(
      {
        account_id: params[:movement][:origin_id],
        transaction_type: 'expense'
      }
    )
  end

  def accounts
    Account.all.order(:name)
  end

  def categories
    Category.all.order(:name)
  end

  def transactions
    TransactionsDecorator.new(Transaction.all.order(:date)).decorate
  end
end
