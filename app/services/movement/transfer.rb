# frozen_string_literal: true

# Class responsable for creating, updating and deleting a transfer
#  and 2 movement (income and expense)
class Movement::Transfer
  def self.create(params_origin, params_destiny)
    new.create(params_origin, params_destiny)
  end

  def self.update(transfer_id, params_origin, params_destiny)
    new.update(transfer_id, params_origin, params_destiny)
  end

  def self.delete(transfer)
    new.delete(transfer)
  end

  def create(params_origin, params_destiny)
    ActiveRecord::Base.transaction do
      origin = Movement.create!(params_origin)
      destiny = Movement.create!(params_destiny)
      Transfer.create!(origin_id: origin.id, destiny_id: destiny.id)
    end
  end

  def update(transfer_id, params_origin, params_destiny)
    transfer = Transfer.find(transfer_id)
    ActiveRecord::Base.transaction do
      origin = transfer.origin
      destiny = transfer.destiny

      origin.update!(params_origin)
      destiny.update!(params_destiny)
      transfer.origin = origin
      transfer.destiny = destiny
      transfer.save
    end
  end

  def delete(transfer)
    Transfer.destroy(transfer.first.id)
  end
end
