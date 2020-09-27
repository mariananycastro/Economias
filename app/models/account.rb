# frozen_string_literal: true

# Account that holds all transactions
class Account < ApplicationRecord
  belongs_to :account_type
  has_many :transactions

  validates :name, presence: true

  enum expiration_type: { dont_have: 0, short: 10, medium: 20, long: 30 }
end
