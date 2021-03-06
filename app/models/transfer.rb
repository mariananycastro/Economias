# frozen_string_literal: true

# Represents relation between two simple_movement, origin: expense, destiny: income
class Transfer < ApplicationRecord
  belongs_to :origin, class_name: 'Movement', dependent: :destroy
  belongs_to :destiny, class_name: 'Movement', dependent: :destroy

  accepts_nested_attributes_for :origin, :destiny

  validates_presence_of :origin, :destiny
  validate :origin_and_destiny_must_be_different

  def origin_and_destiny_must_be_different
    errors.add(:destiny, 'must be differente from origin') if origin.account == destiny.account
  end

  def self.movement_transfer(movement_id)
    where("destiny_id = '#{movement_id}' or origin_id = '#{movement_id}'")
  end
end
