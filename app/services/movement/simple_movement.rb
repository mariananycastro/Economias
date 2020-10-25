# frozen_string_literal: true

# Class responsable for creating, updating and deleting a Simple Movement
# TODO create a transfer with installmente 
class Movement::SimpleMovement

  def self.create(params_simple_movement)
    new.create(params_simple_movement)
  end
 
  def self.update(id, params_simple_movement)
    new.update(id, params_simple_movement)
  end

  def self.delete(id)
    new.delete(id)
  end

  def create(params_simple_movement)
    SimpleMovement.create(params_simple_movement)
  end

  def update(id, params_simple_movement)
    simple_movement = SimpleMovement.find(id)

    simple_movement.update(params_simple_movement)
  end

  def delete(id)
    simple_movement = SimpleMovement.find(id)

    simple_movement.destroy
  end
end
