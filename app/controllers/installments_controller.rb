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

    @comum_params = MovementDecorator.new(params_movement(installment_movement))

    @accounts = accounts
    @categories = categories

    @movements = InstallmentMovement.movements(@installment)
  end

  def update
    Movement::Installment.update(comum_params, installment_params, params[:id])

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
          .permit(:value, :movement_type, :category_id, :account_id)
  end

  def installment_params
    params.require(:installment)
          .permit(:comum_name, :initial_date, :qtd, :interval)
  end

  def params_movement(installment_movement)
    installment = installment_movement.installment
    movement = installment_movement.movement

    movement.name = comum_name(installment.comum_name)
    movement.value = total_value_installment(installment)

    movement
  end

  def comum_name(installment_name)
    installment_name.gsub(/\s\(\d*\sde\s\d*\)/, '')
  end

  def total_value_installment(installment)
    total_value = []
    installment_movements = InstallmentMovement.where(installment: installment)
    installment_movements.each do |i|
      total_value << i.movement.value
    end
    total_value.sum
  end
end
