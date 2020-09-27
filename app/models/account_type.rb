# frozen_string_literal: true

# Types of account ex: Checking account, investiment, Credit card, Prepaid card
class AccountType < ApplicationRecord
  has_many :accounts

  validates :name, presence: true
  validates :name, uniqueness: true
end
