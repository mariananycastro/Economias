# frozen_string_literal: true

# Class responsable for creating, updating and deleting a movement
class Movement::SingleMovement
  def self.altered(installment_movement)
    new.altered(installment_movement)
  end

  def altered(installment_movement)
    installment_movement.altered = true
  end
end