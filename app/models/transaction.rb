# frozen_string_literal: true

class Transaction < ApplicationRecord
  belongs_to :account
  belongs_to :category

  enum transaction_type: { debit: 0, credit: 10, transfer: 20 }
end
