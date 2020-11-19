# frozen_string_literal: true

# class that edits and destroy movements
class InstallmentsController < ApplicationController
  def new
    @installment = InstallmentDecorator.new(Installment.new)
    @movement = MovementDecorator.new(Movement.new)

    @accounts = accounts
    @categories = categories
  end

  def create
    Movement::Installment.create(comum_params, installment_params)

    redirect_to root_path
  end

  private

  def accounts
    Account.all
  end

  def categories
    Category.all
  end

  def comum_params
    params.require(:comum_params)
          .permit(:name, :value, :movement_type, :category_id, :account_id)
  end

  def installment_params
    params.require(:installment)
          .permit(:initial_date, :qtd, :interval)
  end
end
