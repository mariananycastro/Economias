# frozen_string_literal: true

FactoryBot.define do
  factory :category do
    name { |n| "Grocery #{n}" }
  end
end
