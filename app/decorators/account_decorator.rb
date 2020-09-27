# frozen_string_literal: true

# Class to decorate account
class AccountDecorator < Draper::Decorator
  delegate_all

  def account_type_name
    AccountType.find(object.account_type_id).name
  end

  def expiration_names
    Account.expiration_types.map { |k, _v| [Account.human_enum_name(:expiration_types, k), k] }
  end
end
