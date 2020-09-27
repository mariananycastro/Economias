class AccountDecorator < Draper::Decorator
  delegate_all

  def account_type_name
    AccountType.find(object.account_type_id).name
  end
end