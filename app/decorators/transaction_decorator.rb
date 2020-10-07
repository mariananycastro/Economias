# frozen_string_literal: true

# Class to decorate transaction
class TransactionDecorator < Draper::Decorator
  delegate_all

  def type_names
    Transaction.transaction_types.map { |k, _v| [Transaction.human_enum_name(:types, k), k] }
  end

  def account_name
    Account.find(object.account_id).name
  end

  def category_name
    Category.find(object.category_id).name
  end
end
