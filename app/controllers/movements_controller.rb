# frozen_string_literal: true

# class that edits and destroy movements
class MovementsController < ApplicationController
  def new
    @movement = MovementDecorator.new(Movement.new)

    @accounts = ordered_accounts
    @categories = ordered_categories
    @movements = movements
  end

  def create
    Movement::SingleMovement.create(params_movement)

    redirect_to root_path
  end

  def edit
    @movement = MovementDecorator.new(Movement.find(params[:id])).decorate
    @accounts = ordered_accounts
    @categories = ordered_categories
    @movements = movements
  end

  def update
    Movement::SingleMovement.update(params[:id], params_movement)
    redirect_to root_path
  end

  def destroy
    Movement::SingleMovement.delete(params[:id])
    redirect_to root_path
  end

  private

  def params_movement
    params.require(:movement)
          .permit(:name, :value, :date, :movement_type, :account_id, :category_id)
  end

  def movements
    MovementDecorator.new(Movement.all.order(:date)).decorate
  end

  def ordered_accounts
    Account.all.order(:name)
  end

  def ordered_categories
    Category.all.order(:name)
  end

  # def installment_params
  #   params.require(:movement)
  #         .permit(:name, :value, :date, :installments, :category_id, :account_id, :movement_type)
  #         .merge!(type)
  # end

  # def type
  #   return { movement_type: :income } if params[:movement][:movement_type] == INCOME

  #   { movement_type: :expense }
  # end


  # def interval
  #   case params[:movement][:interval]
  #   when day
  #     1.day
  #   when week
  #     1.week
  #   when year
      # 1.year
    # else
      # 1.month
    # end
  # end
end
