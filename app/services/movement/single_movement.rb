# frozen_string_literal: true

# Class responsable for creating, updating and deleting a movement
# rubocop: disable Style/ClassAndModuleChildren
class Movement::SingleMovement
  # rubocop: enable Style/ClassAndModuleChildren
  def self.create(params_movement)
    new.create(params_movement)
  end

  def self.update(id, params_movement)
    new.update(id, params_movement)
  end

  def self.delete(id)
    new.delete(id)
  end

  def create(params_movement)
    Movement.create(params_movement)
  end

  def update(id, params_movement)
    movement = Movement.find(id)

    ActiveRecord::Base.transaction do
      movement.update(params_movement)
      Movement::Installment.update_installment(movement) if movement&.installment_movement
    end
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
