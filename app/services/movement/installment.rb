# frozen_string_literal: true

# Class responsable for creating, updating and deleting a installment
# TODO create a transfer with installmente 
class Movement::Installment

  def self.create(installment_params)
    new.create(installment_params)
  end

  def self.update(simple_movement_id)
    new.update(simple_movement_id)
  end

  def self.delete(simple_movement_id)
    new.delete(simple_movement_id)
  end

  def create(installment_params)
    @name = installment_params[:name]
    @date = installment_params[:date].to_date
    @installment = installment_params[:installments].to_i
    @category = installment_params[:category_id]
    @account = installment_params[:account_id]
    @simple_movement_value = installment_params[:value].to_f / @installment
    @simple_movement_type = installment_params[:simple_movement_type]
    @interval = 1.month #params_installment[:interval]

    params_installment = build_installment
    i = 1
    installment_date = @date
    ActiveRecord::Base.transaction do
      new_installment = Installment.create
      while i <= @installment
        params_installment.merge!({
                                    name: "#{@name} (#{i} de #{@installment})",
                                    value: @simple_movement_value,
                                    date: installment_date
                                  })

        @simple_movement = SimpleMovement.new(params_installment)
        @simple_movement.save
        
        InstallmentSimpleMovement.create!(installment: new_installment, simple_movement: @simple_movement)
        installment_date = installment_date + @interval
        i += 1
      end
    end
  end

  def update(simple_movement_id)
    binding.pry
    simple_movement = SimpleMovement.find(simple_movement_id)
    installment = simple_movement.installment_simple_movement.installment

    installments = InstallmentSimpleMovement.where(installment: installment)

    movements = [] 
    installments.each do |installment|
      movements << installment[:simple_movement]
    end

    # build_params(simple_movement, params_installment)

    # ActiveRecord::Base.transaction do
    #   movements.each do |movement| 
    #     movement.
    #   end
    # end
  end

  def delete(simple_movement_id)
    simple_movement = SimpleMovement.find(simple_movement_id)
    installment = simple_movement.installment_simple_movement.installment
    installment_simple_movements = installment.installment_simple_movements

    ActiveRecord::Base.transaction do
      installment_simple_movements.each do |i|
        movement = i.simple_movement
        i.delete
        movement.delete
      end
      installment.delete
    end
  end

  private

  def build_installment
    {
      simple_movement_type: @simple_movement_type,
      category_id: @category,
      account_id: @account
    }
  end

  def build_params(simple_movement, params_installment)
    { 
      name: params[:name],
      value: params[:value],
      date: params[:date],
      simple_movement_type: params[:simple_movement_type],
      account_id: params[:account_id],
      category_is: params[:category_is]
    }
  end
end
