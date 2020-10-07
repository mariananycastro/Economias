# frozen_string_literal: true

# Class that creates transfer with 2 transactions (income and expense)
class TransfersController < ApplicationController
  def new
    @income = Transaction.new
    @expense = Transaction.new
    @transfer = Transfer.new
    @accounts = ordered_accounts
    @categories = ordered_categories

    @transactions = transactions
  end

  def create
    return redirect_to root_path if ActiveRecord::Base.transaction do
      @income = Transaction.create!(params_income)
      @expense = Transaction.create!(params_expense)
      @transfer = Transfer.create!(origin_id: @expense.id, destiny_id: @income.id)
      @income.update!(transfer: @transfer)
      @expense.update!(transfer: @transfer)
    end
    
    render :new
  end


  def destroy
    Transfer.find(params[:transfer]).destroy
  end

  private

  def params_transf
    params.require(:transfer)
          .permit(:name, :value, :date, :category_id)
  end

  def params_income
    params_transf.merge(
      {
        account_id: params[:transfer][:destiny],
        transaction_type: 0
      }
    )
  end

  def params_expense
    params_transf.merge(
      {
        account_id: params[:transfer][:origin],
        transaction_type: 10
      }
    )
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

  def transactions
    Transaction.all.order(:date)
  end
end
