# frozen_string_literal: true

# Represents transaction on account, can be debit(positive) ou credit(negative)
# When it belongs to a transfer, each transfer has 2 transaction, debit and credit
class Transaction < ApplicationRecord
  belongs_to :account
  belongs_to :category
  belongs_to :transfer, optional: true

  validates :name, :value, :date, :transaction_type, presence: true
  validates_numericality_of :value, greater_than_or_equal_to: 0.01

  enum transaction_type: { debit: 0, credit: 10 }
end
