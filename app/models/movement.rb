# frozen_string_literal: true

# Class responsable for the creation of a transaction or transfer
class Movement
  include ActiveModel::Model

  attr_accessor :name,
                :value,
                :date,
                :category_id,
                :origin_id,
                :destiny_id,
                :account_id,
                :transaction_type
end
