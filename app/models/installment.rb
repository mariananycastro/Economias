# frozen_string_literal: true

# table of installment which will be assigned to some movements
class Installment < ApplicationRecord
  has_many :installment_movements, dependent: :destroy

  validates :qtd, :interval, :initial_date, presence: true
  validates_numericality_of :qtd, greater_than: 0

  enum interval: { yearly: 0, monthly: 10, weekly: 20, daily: 30 }
end
