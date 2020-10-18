class InstallmentSimpleMovement < ApplicationRecord
  belongs_to :installment
  belongs_to :simple_movement
end
