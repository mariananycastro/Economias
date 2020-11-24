# frozen_string_literal: true

# Class responsable for creating, updating and deleting a installment
# TODO create a transfer with installment
# rubocop: disable Style/ClassAndModuleChildren
class Movement::Installment
  # rubocop: enaable Style/ClassAndModuleChildren
  def initialize(comum_params, installment_params, id = 0)
    @name = installment_params[:comum_name]
    @installment_qtd = installment_params[:qtd].to_i
    @movement_value = comum_params[:value].to_f / @installment_qtd
    @date = installment_params[:initial_date].to_date
    @interval = installment_params[:interval]

    @movement_type = comum_params[:movement_type]
    @category_id = comum_params[:category_id]
    @account_id = comum_params[:account_id]
    @id = id
  end

  def self.create(comum_params, installment_params)
    new(comum_params, installment_params).create
  end

  def self.update(comum_params, installment_params, id)
    new(comum_params, installment_params, id).update
  end

  def create
    create_installment
  end

  def update
    installment = Installment.find(@id)
    movements = InstallmentMovement.movements(installment)

    if movements.count == @installment_qtd
      update_movements_and_installment(movements)
    else
      delete_and_create_installment(installment.id)
    end
  end

  def self.delete_single_movement(movement_id)
    binding.pry
    installment = InstallmentMovement.installment_of_movement(movement_id)
    movements = InstallmentMovement.movements(installment) #exceto o movement atual
    initial_date = #menor_data

    ActiveRecord::Base.transaction do
      Movement.destroy(movement_id)
      installment.qtd -= 1
      installment.initial_date = initial_date
      movement.installment_movement.altered = true
    end
  end

  def self.delete_installment(installment)
    Installment.destroy(installment.id)
  end

  private

  def create_installment
    ActiveRecord::Base.transaction do
      new_installment = Installment.create(comum_name: @name,
                                           qtd: @installment_qtd,
                                           interval: @interval,
                                           initial_date: @date)

      params_movements.each do |params_movement|
        movement = Movement.create(params_movement)
        InstallmentMovement.create(installment: new_installment, movement: movement)
      end
    end
  end

  def installments_interval
    return 1.day if @interval == 'daily'
    return 1.week if @interval == 'weekly'
    return 1.month if @interval == 'monthly'
    return 1.year if @interval == 'yearly'
  end

  def params_movement
    { movement_type: @movement_type,
      value: @movement_value,
      category_id: @category_id,
      account_id: @account_id }
  end

  def params_movements
    i = 1
    installment_date = @date
    movements = []

    while i <= @installment_qtd
      movements << params_movement.merge!({ name: "#{@name} (#{i} de #{@installment_qtd})",
                                            date: installment_date })
      installment_date += installments_interval
      i += 1
    end
    movements
  end

  def update_movements_and_installment(movements)
    i = 0
    build_movement = params_movements
    ActiveRecord::Base.transaction do
      while i < movements.count
        movements[i].update(build_movement[i])
        i += 1
      end
      installment = InstallmentMovement.installment_of_movement(movements.first)
      installment.update(comum_name: @name, interval: @interval, initial_date: @date)
    end
  end

  def delete_and_create_installment(installment_id)
    ActiveRecord::Base.transaction do
      Installment.destroy(installment_id)
      create_installment
    end
  end
end
