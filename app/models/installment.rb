class Installment < ApplicationRecord
  has_many :installment_simple_movements, dependent: :destroy
end
