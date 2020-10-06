# frozen_string_literal: true

# Class that creates transfer with 2 transactions (debit and credit)
class TransfersController < ApplicationController
  def new
    @debit = Transaction.new
    @credit = Transaction.new
    @transfer = Transfer.new
    @accounts = ordered_accounts
    @categories = ordered_categories

    @transactions = transactions
  end

  def create
    @debit = Transaction.new(params_debit)
    @credit = Transaction.new(params_credit)

    if @debit.save && @credit.save
      @transfer = Transfer.new(origin_id: @credit.id, destiny_id: @debit.id)
    end

    return redirect_to root_path if @transfer.save

    render :new
  end

  private
  
  def params_transf
    params.require(:transfer)
    .permit(:name, :value, :date, :origin, :destiny, :category_id )
  end

  def params_debit
    {
      name: params[:transfer][:name],
      value: params[:transfer][:value],
      date: params[:transfer][:date],
      account_id: params[:transfer][:origin],
      category_id: params[:transfer][:category_id],
      transaction_type: 0
    }
  end

  def params_credit
    {
      name: params[:transfer][:name],
      value: params[:transfer][:value],
      date: params[:transfer][:date],
      account_id: params[:transfer][:destiny],
      category_id: params[:transfer][:category_id],
      transaction_type: 10
    }
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
