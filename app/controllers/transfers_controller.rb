# frozen_string_literal: true

# Class that creates transfer with 2 simple movement (income and expense)
class TransfersController < ApplicationController
  def edit
    @transfer = Transfer.find(params[:id])

    @accounts = ordered_accounts
    @categories = ordered_categories

    @simple_movements = SimpleMovementDecorator.new(simple_movements).decorate
  end

  def update
    Movement::Transfer.update(params[:id], params_origin, params_destiny)

    return redirect_to root_path
  end

  def destroy
    Movement::Transfer.delete(params[:id])

    return redirect_to root_path
  end

  private

  def ordered_accounts
    Account.all.order(:name)
  end

  def ordered_categories
    Category.all.order(:name)
  end

  def simple_movements
    SimpleMovement.all.order(:date)
  end

  def params_simple_movement
    params.require(:transfer)
           .permit({ origin_attributes: %i[name value date category_id] })
           .dig(:origin_attributes)
  end

  def params_origin
    params_simple_movement.merge!(
      {
        id: params[:transfer][:origin_attributes][:id],
        account_id: params[:transfer][:origin_attributes][:origin_id],
        simple_movement_type: 'expense'
      }
    )
  end

  def params_destiny
    params_simple_movement.merge!(
      {
        id: params[:transfer][:destiny_attributes][:id],
        account_id: params[:transfer][:destiny_attributes][:destiny_id],
        simple_movement_type: 'income'
      }
    )
  end
end
