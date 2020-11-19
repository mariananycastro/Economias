# frozen_string_literal: true

# Class to decorate movement
class InstallmentDecorator < Draper::Decorator
  delegate_all

  def interval_names
    Installment.intervals.map { |k, _v| [Installment.human_enum_name(:intervals, k), k] }
  end
end