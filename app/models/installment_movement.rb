# frozen_string_literal: true

# table of reference between installment and movements
class InstallmentMovement < ApplicationRecord
  belongs_to :installment
  belongs_to :movement, dependent: :destroy

  def self.installments(installment)
    where(installment: installment)
  end

  def self.movements(installment)
    movements = []
    installments = InstallmentMovement.where(installment: installment)
    installments.each do |i|
      movements << i.movement
    end
    movements
  end

  def self.installment_of_movement(movement_id)
    find_by(movement_id: movement_id)&.installment
  end
end
