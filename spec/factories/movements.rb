# frozen_string_literal: true

FactoryBot.define do
  factory :movement do
    name { 'Supermercado X' }
    value { 10 }
    date { Date.today }
    movement_type { 'expense' }
    account
    category
  end
end
