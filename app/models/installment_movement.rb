# frozen_string_literal: true

# table of reference between installment and movements
class InstallmentMovement < ApplicationRecord
  belongs_to :installment
  belongs_to :movement
end
