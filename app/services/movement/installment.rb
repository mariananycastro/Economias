# frozen_string_literal: true

# Class responsable for creating, updating and deleting a installment
# TODO create a transfer with installment
# rubocop: disable Style/ClassAndModuleChildren
class Movement::Installment
  # rubocop: enable Style/ClassAndModuleChildren
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
    Installment::Create.create_installment(params_installment, params_movements)
  end

  def update
    installment = Installment.find(@id)
    movements = InstallmentMovement.movements(installment)

    if movements.count == @installment_qtd
      Installment::Update.update_movements_and_installment(movements, params_movements, params_installment)
    else
      Installment::Update.delete_and_create_installment(installment.id, params_installment, params_movements)
    end
  end

  def self.update_installment(movement)
    Installment::Update.update_installment(movement)
  end

  def self.delete_single_movement(movement_id)
    Installment::Delete.single_movement(movement_id)
  end

  def self.delete_installment(installment_movement_id)
    Installment::Delete.installment(installment_movement_id)
  end

  private

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

  def params_installment
    { comum_name: @name,
      qtd: @installment_qtd,
      interval: @interval,
      initial_date: @date }
  end
end
