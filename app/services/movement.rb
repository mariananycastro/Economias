# frozen_string_literal: true

# Class responsable for creating, updating and deleting a Simple Movement
# TODO create a transfer with installment
class Movement
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

  def update(id, params__movement)
    movement = Movement.find(id)

    movement.update(params_movement)
  end

  def delete(id)
    movement = Movement.find(id)

    movement.destroy
  end
end
