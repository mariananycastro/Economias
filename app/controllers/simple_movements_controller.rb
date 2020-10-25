# frozen_string_literal: true

class SimpleMovementsController < ApplicationController
  def edit
    @simple_movement = SimpleMovementDecorator.new(SimpleMovement.find(params[:id])).decorate
    @accounts = ordered_accounts
    @categories = ordered_categories
    @simple_movements = simple_movements
  end

  def update
    Movement::SimpleMovement.update(params[:id], params_simple_movement)
    return redirect_to root_path
  end

  def destroy
    Movement::SimpleMovement.delete(params[:id])
    return redirect_to root_path 
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
end
