# frozen_string_literal: true

FactoryBot.define do
  factory :transaction do
    name { "MyString" }
    value { "9.99" }
    date { "2020-09-27" }
    account_id {  create(:account).id}
    category_id {  create(:category).id}
  
    trait :income do
      transaction_type { 0 }
    end

    trait :expense do
      transaction_type { 10 }
    end
  end
end
