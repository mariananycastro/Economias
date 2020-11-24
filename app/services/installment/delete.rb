# frozen_string_literal: true

# class responsable for deleting a installment

# rubocop: disable Style/ClassAndModuleChildren
class Installment::Delete
  # rubocop: enable Style/ClassAndModuleChildren

  def self.single_movement(movement_id)
    movement = Movement.find(movement_id)
    installment_movement = movement.installment_movement
    installment = installment_movement.installment
    movements = movements(installment, movement_id)
    new_initial_date = (movements.min { |a, b| a.date <=> b.date }).date

    ActiveRecord::Base.transaction do
      InstallmentMovement.destroy(installment_movement.id)
      installment.update(qtd: installment.qtd - 1, initial_date: new_initial_date)
    end
  end

  def self.installment(installment_movement_id)
    installment_movement = InstallmentMovement.find(installment_movement_id)
    installment = installment_movement.installment
    Installment.destroy(installment.id)
  end

  def self.movements(installment, movement_id)
    movements = InstallmentMovement.movements(installment)
    movements.delete_if { |mov| mov.id == movement_id.to_i }
  end
end
