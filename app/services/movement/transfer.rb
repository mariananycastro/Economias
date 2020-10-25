# frozen_string_literal: true

# Class responsable for creating, updating and deleting a transfer
#  and 2 simple movement (income and expense)
class Movement::Transfer

  def self.create(params_income, params_expense)
    new.create(params_income, params_expense)
  end

  def self.update(transfer_id, params_origin, params_destiny)
    new.update(transfer_id, params_origin, params_destiny)
  end

  def self.delete(transfer_id)
    new.delete(transfer_id)
  end

  def create(params_income, params_expense)
    ActiveRecord::Base.transaction do
      income = SimpleMovement.create!(params_income)
      expense = SimpleMovement.create!(params_expense)
      transfer = Transfer.create!(origin_id: expense.id, destiny_id: income.id)
      income.update!(transfer: transfer)
      expense.update!(transfer: transfer)
    end
  end

  def update(transfer_id, params_origin, params_destiny)
    transfer = Transfer.find(transfer_id)
    ActiveRecord::Base.transaction do
      origin = SimpleMovement.find(params_origin[:id])
      destiny = SimpleMovement.find(params_destiny[:id])

      origin.update!(params_origin)
      destiny.update!(params_destiny)
      transfer.origin = origin
      transfer.destiny = destiny
      transfer.save
    end
  end

  def delete(transfer_id)
    Transfer.find(transfer_id).destroy
  end
end