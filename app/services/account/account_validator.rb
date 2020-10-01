# frozen_string_literal: true

# Account that holds all transactions
class Account::AccountValidator < ActiveModel::Validator
  OPENING_BALANCE = 0

  def validate(account)
    validate_initial_value(account)
    validate_status_active(account)
  end

  private

  def validate_initial_value(account)
    return account.initial_value = OPENING_BALANCE if account.initial_value.nil?
  end

  def validate_status_active(account)
    return account.active = true if account.active.nil?
  end
end
