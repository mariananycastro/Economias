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
    Movement.create(params_movement)

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
    movement = Movement.find(params[:id])
    movement.update(params_movement)

    redirect_to root_path
  end

  def destroy
    transfer = movement_transfer

    if transfer.empty?
      Movement.destroy(params[:id])
    else
      Movement::Transfer.delete(transfer)
    end

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
    Transfer.where("destiny_id = '#{params[:id]}' or origin_id = '#{params[:id]}'")
  end
end
