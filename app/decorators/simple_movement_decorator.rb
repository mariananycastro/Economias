# frozen_string_literal: true

# Class to decorate simple movement
class SimpleMovementDecorator < Draper::Decorator
  delegate_all

  def type_names
    SimpleMovement.simple_movement_types.map { |k, _v| [SimpleMovement.human_enum_name(:types, k), k] }
  end

  def account_name
    Account.find(object.account_id).name
  end

  def category_name
    Category.find(object.category_id).name
  end
end
