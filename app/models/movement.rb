# frozen_string_literal: true

# Class responsable for the creation of a movement
class Movement
  include ActiveModel::Model

  attr_accessor :name,
                :value,
                :date,
                :category_id,
                :origin_id,
                :destiny_id,
                :account_id,
                :simple_movement_type,
                :installments
end
