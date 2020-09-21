# frozen_string_literal: true

# Account that holds all transactions
class Account < ApplicationRecord
  validates :name, :status, presence: true

  belongs_to :account_type
end
