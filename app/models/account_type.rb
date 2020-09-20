# frozen_string_literal: true

# Types of account ex: Checking account, investiment, Credit card, Prepaid card
class AccountType < ApplicationRecord
  validates :name, presence: true
  validates :name, uniqueness: true

  has_many :accounts
end
