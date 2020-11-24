# frozen_string_literal: true

# class responsable for creating a installment

# rubocop: disable Style/ClassAndModuleChildren
class Installment::Create
  # rubocop: enable Style/ClassAndModuleChildren

  def self.create_installment(params_installment, params_movements)
    ActiveRecord::Base.transaction do
      new_installment = Installment.create(params_installment)

      params_movements.each do |params_movement|
        movement = Movement.create(params_movement)
        InstallmentMovement.create(installment: new_installment, movement: movement)
      end
    end
  end
end
