# frozen_string_literal: true

# Class responsable for creating, updating and deleting a movement
# rubocop: disable Style/ClassAndModuleChildren
class Movement::InstallmentMovements
  # rubocop: enable Style/ClassAndModuleChildren
  def self.altered(installment_movement)
    new.altered(installment_movement)
  end

  def altered(installment_movement)
    installment_movement.update(altered: true)
  end
end
