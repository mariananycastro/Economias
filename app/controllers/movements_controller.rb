# frozen_string_literal: true

# Class responsable for creating a movement
class MovementsController < ApplicationController
  INCOME = '0'

  def new
    @movement = Movement.new

    @accounts = accounts
    @categories = categories
    @simple_movements = simple_movements
  end

  def create
    if installment?
      Movement::Installment.create(installment_params)
    elsif simple_movement?
      Movement::SimpleMovement.create(params_simple_movement)
    else
      Movement::Transfer.create(params_income, params_expense)
    end
    return redirect_to root_path
  end

  private

  def installment?
    !params[:movement][:installments].nil?
  end

  def simple_movement?
    !params[:movement][:account_id].nil?
  end

  def params_simple_movement
    params.require(:movement)
          .permit(:name, :value, :date, :category_id, :account_id, :simple_movement_type)
          .merge!(type)
  end

  def installment_params
    params.require(:movement)
          .permit(:name, :value, :date, :installments, :category_id, :account_id, :simple_movement_type)
          .merge!(type)
  end

  def type
    return { simple_movement_type: 'income' } if params[:movement][:simple_movement_type] == INCOME

    { simple_movement_type: 'expense' }
  end

  def params_transfer
    params.require(:movement)
          .permit(:name, :value, :date, :category_id)
  end

  def params_income
    params_transfer.merge(
      {
        account_id: params[:movement][:destiny_id],
        simple_movement_type: 'income'
      }
    )
  end

  def params_expense
    params_transfer.merge(
      {
        account_id: params[:movement][:origin_id],
        simple_movement_type: 'expense'
      }
    )
  end

  def accounts
    Account.all.order(:name)
  end

  def categories
    Category.all.order(:name)
  end

  def simple_movements
    SimpleMovementDecorator.new(SimpleMovement.all.order(:date)).decorate
  end

  def interval
    case params[:movement][:interval]
    when day
      1.day
    when week
      1.week
    when year
      1.year
    else
      1.month
    end
  end
end
