# frozen_string_literal: true

# Class that creates Simple movements: income, expense
class SimpleMovementsController < ApplicationController
  def edit
    @simple_movement = SimpleMovementDecorator.new(simple_movement).decorate
    @accounts = ordered_accounts
    @categories = ordered_categories
    @simple_movements = simple_movements
  end

  def update
    @simple_movement = simple_movement
    if @simple_movement.transfer.nil?
      return redirect_to root_path if @simple_movement.update(params_simple_movement)
    end

    render :edit
  end

  def destroy
    @simple_movement = simple_movement

    return redirect_to root_path if delete_simple_movement

    render :edit
  end

  private

  def params_simple_movement
    params.require(:simple_movement)
          .permit(:name, :value, :date, :simple_movement_type, :account_id, :category_id)
  end

  def simple_movements
    SimpleMovementDecorator.new(SimpleMovement.all.order(:date)).decorate
  end

  def ordered_accounts
    Account.all.order(:name)
  end

  def ordered_categories
    Category.all.order(:name)
  end

  def simple_movement
    SimpleMovement.find(params[:id])
  end

  def simple_movement_transfer
    simple_movement.transfer
  end

  def delete_simple_movement
    @simple_movement.destroy if simple_movement_transfer.nil?
  end
end
