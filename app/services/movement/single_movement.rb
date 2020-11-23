# frozen_string_literal: true

# Class responsable for creating, updating and deleting a movement
class Movement::SingleMovement
  def self.create(params_movement)
    new.create(params_movement)
  end

  def create(params_movement)
    Movement.create(params_movement)
  end

  def self.update(id, params_movement)
    new.update(id, params_movement)
  end

  def update(id, params_movement)
    movement = Movement.find(id)
    Movement::SingleMovement.altered(movement.installment_movement) if movement.installment_movement
    movement.update(params_movement)
  end

  def self.delete(id)
    new.delete(id)
  end

  def delete(movement_id)
    transfer = Transfer.movement_transfer(movement_id)
    installment = InstallmentMovement.installment_of_movement(movement_id)

    if !transfer.empty?
      Movement::Transfer.delete(transfer)
    elsif installment
      Movement::Installment.delete(installment)
    else
      Movement.destroy(movement_id)
    end

  end
end