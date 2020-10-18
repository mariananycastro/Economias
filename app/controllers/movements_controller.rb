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
      params_installment = installment_params
      name = params_installment[:name]
      installment = params_installment[:installments].to_i
      simple_movement_value = params_installment[:value].to_f / installment
      date = params_installment[:date].to_date
      params_installment = comum_params_installments

      i = 1
      interval = 1.month #interval
      ActiveRecord::Base.transaction do
        while i <= installment
          params_installment.merge!({
                                      name: "#{name} (#{i} 'de' #{installment})",
                                      value: simple_movement_value,
                                      date: date
                                    })

          @simple_movement = SimpleMovement.new(params_installment)
          @simple_movement.save
          new_installment = Installment.create!
          InstallmentSimpleMovement.create!(installment: new_installment, simple_movement: @simple_movement)
          date = date + interval
          i += 1
        end
        return redirect_to root_path
      end
    elsif simple_movement?
      @simple_movement = SimpleMovement.new(params_simple_movement)
      return redirect_to root_path if @simple_movement.save
    else

      return redirect_to root_path if ActiveRecord::Base.transaction do
        @income = SimpleMovement.create!(params_income)
        @expense = SimpleMovement.create!(params_expense)
        @transfer = Transfer.create!(origin_id: @expense.id, destiny_id: @income.id)
        @income.update!(transfer: @transfer)
        @expense.update!(transfer: @transfer)
      end
    end

    render :new
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
          .permit(:name, :value, :date, :installments)
  end

  def comum_params_installments
    params.require(:movement)
          .permit(:category_id, :account_id, :simple_movement_type)
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
