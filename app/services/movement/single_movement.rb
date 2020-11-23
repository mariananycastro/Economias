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
    movement.update(params_movement)
  end

  def self.delete(id, transfer)
    new.delete(id, transfer)
  end

  def delete(id, transfer)
    if transfer.empty?
      Movement.destroy(id)
    else
      Movement::Transfer.delete(transfer)
    end

  end
end