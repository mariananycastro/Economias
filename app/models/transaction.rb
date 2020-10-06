# frozen_string_literal: true

class Transaction < ApplicationRecord
  belongs_to :account
  belongs_to :category

  validates :name, :value, :date, :transaction_type, presence: true
  validates_numericality_of :value, greater_than_or_equal_to: 0.01

  enum transaction_type: { debit: 0, credit: 10 }
end
