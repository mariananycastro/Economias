# frozen_string_literal: true

# class responsable for updating a installment

# rubocop: disable Style/ClassAndModuleChildren
class Installment::Update
  # rubocop: enable Style/ClassAndModuleChildren
  def self.update_movements_and_installment(movements, params_movements, params_installment)
    i = 0
    build_movement = params_movements
    ActiveRecord::Base.transaction do
      while i < movements.count
        movements[i].update(build_movement[i])
        i += 1
      end
      installment = InstallmentMovement.installment_of_movement(movements.first)
      installment.update(params_installment)
    end
  end

  def self.delete_and_create_installment(installment_id, params_installment, params_movements)
    ActiveRecord::Base.transaction do
      Installment.destroy(installment_id)
      Installment::Create.create_installment(params_installment, params_movements)
    end
  end

  def self.update_installment(movement)
    installment = movement.installment_movement.installment
    Movement::InstallmentMovements.altered(movement.installment_movement) if movement.installment_movement

    movements = InstallmentMovement.movements(installment)
    new_initial_date = (movements.min { |a, b| a.date <=> b.date }).date

    installment.update(initial_date: new_initial_date) if installment.initial_date != new_initial_date
  end
end
