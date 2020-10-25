# frozen_string_literal: true

# Class responsable for creating, updating and deleting a installment
# TODO create a transfer with installmente 
class Movement::Installment

  def initialize(installment_params)
    @name = installment_params[:name]
    @date = installment_params[:date].to_date
    @installment = installment_params[:installments].to_i
    @category = installment_params[:category_id]
    @account = installment_params[:account_id]
    @simple_movement_value = installment_params[:value].to_f / @installment
    @simple_movement_type = installment_params[:simple_movement_type]
    @interval = 1.month #params_installment[:interval]
  end


  def self.create(installment_params)
    new(installment_params).create
  end

  def create
    params_installment = build_installment
    i = 1
    installment_date = @date
    ActiveRecord::Base.transaction do
      while i <= installment
        params_installment.merge!({
                                    name: "#{@name} (#{i} 'de' #{@installment})",
                                    value: @simple_movement_value,
                                    date: installment_date
                                  })

        @simple_movement = SimpleMovement.new(params_installment)
        @simple_movement.save
        new_installment = Installment.create!
        InstallmentSimpleMovement.create!(installment: new_installment, simple_movement: @simple_movement)
        installment_date = installment_date + @interval
        i += 1
      end
    end
  end
  # InstallmentSimpleMovement.find_by(simple_movement: 41)[:installment_id]
  private

  def build_installment
    {
      simple_movement_type: @simple_movement_type,
      category_id: @category,
      account_id: @account
    }
  end
end
