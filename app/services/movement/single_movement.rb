# frozen_string_literal: true

# Class responsable for creating, updating and deleting a movement
# rubocop: disable Style/ClassAndModuleChildren
class Movement::SingleMovement
  # rubocop: enable Style/ClassAndModuleChildren
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
    movement = Movement.find(movement_id)
    installment_movement = movement&.installment_movement
    if !transfer.empty?
      Movement::Transfer.delete(transfer)
    elsif !installment_movement.nil?
      Movement::Installment.delete_single_movement(movement_id)
    else
      Movement.destroy(movement_id)
    end
  end
end
 