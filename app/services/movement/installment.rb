# frozen_string_literal: true

# Class responsable for creating, updating and deleting a installment
# TODO create a transfer with installment
class Movement::Installment
  def initialize(comum_params, installment_params)
    @name = comum_params[:name]
    @installment_qtd = installment_params[:qtd].to_i
    @movement_value = comum_params[:value].to_f / @installment_qtd
    @date = installment_params[:initial_date].to_date
    @interval = installment_params[:interval]

    @movement_type = comum_params[:movement_type]
    @category_id = comum_params[:category_id]
    @account_id = comum_params[:account_id]
  end

  def self.create(comum_params, installment_params)
    new(comum_params, installment_params).create
  end

  def create
    i = 1
    installment_date = @date

    ActiveRecord::Base.transaction do
      new_installment = Installment.create(qtd: @installment_qtd, interval: @interval, initial_date: @date)

      while i <= @installment_qtd
        new_movement = params_movement.merge!({ name: "#{@name} (#{i} de #{@installment_qtd})",
                                 value: @movement_value,
                                 date: installment_date })

        movement = Movement.create(new_movement)

        InstallmentMovement.create(installment: new_installment, movement: movement)
        installment_date = installment_date + installments_interval
        i += 1
      end
    end
  end

  # def update(params)
    # movement = Movement.find(movement_id)
    # installment = movement.installment_movement.installment

    # installments = InstallmentMovement.where(installment: installment)

    # movements = []
    # installments.each do |installment|
    #   movements << installment[:movement]
    # end

    # build_params(movement, params_installment)

    # ActiveRecord::Base.transaction do
    #   movements.each do |movement|
    #     movement.installments_interval
    #   end
    # end
  # end

  # def delete(movement_id)
  #   movement = Movement.find(movement_id)
  #   installment = movement.installment_movement.installment
  #   installment_movements = installment.installment_movements

  #   ActiveRecord::Base.transaction do
  #     delete_all_installment_movements(installment_movements)
  #     installment.delete
  #   end
  # end

  private

  def params_movement
    { movement_type: @movement_type,
      category_id: @category_id,
      account_id: @account_id }
  end

  def installments_interval
    return 1.day if @interval == 'daily'
    return 1.week if @interval == 'weekly'
    return 1.month if @interval == 'monthly'
    return 1.year if @interval == 'yearly'
  end
end
