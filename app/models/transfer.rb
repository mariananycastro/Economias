# frozen_string_literal: true

# Represents relation between two transactions, origin: expense, destiny: income
class Transfer < ApplicationRecord
  belongs_to :origin, class_name: 'Transaction'
  belongs_to :destiny, class_name: 'Transaction'
  has_many :transactions, dependent: :destroy

  accepts_nested_attributes_for :origin, :destiny

  validates_presence_of :origin, :destiny
  validate :origin_and_destiny_must_be_different

  def origin_and_destiny_must_be_different
    errors.add(:destiny, 'must be differente from origin') if origin.account == destiny.account
  end
end
