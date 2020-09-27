# frozen_string_literal: true

# Account that holds all transactions
class Account < ApplicationRecord
  belongs_to :account_type
  has_many :transactions

  validates :name, presence: true

  enum expiration_type: { short: 0, medium: 10, long: 20 }
end
