# frozen_string_literal: true

FactoryBot.define do
  factory :installment do
    comum_name { 'Supermercado X' }
    qtd { 2 }
    initial_date { Date.today }
    interval { 'monthly' }
  end
end
