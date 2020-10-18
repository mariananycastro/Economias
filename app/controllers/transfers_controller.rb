# frozen_string_literal: true

# Class that creates transfer with 2 simple movement (income and expense)
class TransfersController < ApplicationController
  def edit
    @transfer = transfer

    @accounts = ordered_accounts
    @categories = ordered_categories

    @simple_movements = SimpleMovementDecorator.new(simple_movements).decorate
  end

  def update
    @transfer = transfer
    @params = params

    return redirect_to root_path if ActiveRecord::Base.transaction do
      origin = SimpleMovement.find(params[:transfer][:origin_attributes][:id])
      destiny = SimpleMovement.find(params[:transfer][:destiny_attributes][:id])

      origin.update!(params_origin)
      destiny.update!(params_destiny)
      @transfer.origin = origin
      @transfer.destiny = destiny
      @transfer.save
    end

    render :edit
  end

  def destroy
    return redirect_to root_path if transfer.destroy

    render :edit
  end

  private

  def transfer
    Transfer.find(params[:id])
  end

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
    @params.require(:transfer)
           .permit({ origin_attributes: %i[name value date category_id] })
           .dig(:origin_attributes)
  end

  def params_origin
    params_simple_movement.merge!(
      {
        account_id: @params[:transfer][:origin_attributes][:origin_id],
        simple_movement_type: 'expense'
      }
    )
  end

  def params_destiny
    params_simple_movement.merge!(
      {
        account_id: @params[:transfer][:destiny_attributes][:destiny_id],
        simple_movement_type: 'income'
      }
    )
  end
end
