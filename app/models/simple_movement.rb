# frozen_string_literal: true

# Represents simple_movement on account, can be income(positive) ou expense(negative)
# When it belongs to a transfer, each transfer has 2 simple_movement, income and expense
class SimpleMovement < ApplicationRecord
  belongs_to :account
  belongs_to :category
  belongs_to :transfer, optional: true
  has_one :installment_simple_movement

  validates :name, :value, :date, :simple_movement_type, presence: true
  validates_numericality_of :value, greater_than_or_equal_to: 0.01

  enum simple_movement_type: { income: 0, expense: 10 }
end
