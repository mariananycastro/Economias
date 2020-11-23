# frozen_string_literal: true

# class that edits and destroy movements
class InstallmentsController < ApplicationController
  def new
    @installment = InstallmentDecorator.new(Installment.new)
    @comum_params = MovementDecorator.new(Movement.new)

    @accounts = accounts
    @categories = categories
  end

  def create
    Movement::Installment.create(comum_params, installment_params)

    redirect_to root_path
  end

  def edit
    installment_movement = InstallmentMovement.find(params[:id])
    @installment = InstallmentDecorator.new(installment_movement.installment)

    @comum_params = MovementDecorator.new(inf_movement(installment_movement))

    @accounts = accounts
    @categories = categories
  end

  def update
    Movement::Installment.update(comum_params, installment_params, params[:id].to_i)

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

  def inf_movement(installment_movement)
    movement = installment_movement.movement
    comum_name = movement.name.gsub(/\s\(\d*\sde\s\d*\)/, '')
    movement.name = comum_name
    qtd_parcelas = InstallmentMovement.where(installment: 1).count
    movement.value = movement.value * qtd_parcelas
    movement
  end
end
