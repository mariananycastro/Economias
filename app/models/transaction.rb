# frozen_string_literal: true

class Transaction < ApplicationRecord
  belongs_to :account
  belongs_to :category

  enum type: { debit: 0, credit: 10, tranfer: 20 }
end
