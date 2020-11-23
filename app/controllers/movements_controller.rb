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
    transfer = movement_transfer

    redirect_to edit_transfer_path(transfer.first.id) unless transfer.empty?
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

  def movement_transfer
    Transfer.movement_transfer(params[:id])
  end
end
