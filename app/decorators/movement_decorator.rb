# frozen_string_literal: true

# Class to decorate movement
class MovementDecorator < Draper::Decorator
  delegate_all

  def type_names
    Movement.movement_types.map { |k, _v| [Movement.human_enum_name(:movement_types, k), k] }
  end

  def account_name
    Account.find(object.account_id).name
  end

  def category_name
    Category.find(object.category_id).name
  end
end
