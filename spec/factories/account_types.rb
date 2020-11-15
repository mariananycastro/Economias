# frozen_string_literal: true

FactoryBot.define do
  factory :account_type do
    name { |n| "CC #{n}"}
  end
end
