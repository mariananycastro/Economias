# frozen_string_literal: true

# Account that holds all transactions
class Account < ApplicationRecord
  belongs_to :account_type
  has_one :expiration_type
  has_many :transactions

  validates :name, :status, presence: true
end
