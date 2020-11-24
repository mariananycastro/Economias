# frozen_string_literal: true

FactoryBot.define do
  factory :installment_movement do
    installment
    movement
  end
end
