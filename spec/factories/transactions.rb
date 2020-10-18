# frozen_string_literal: true

FactoryBot.define do
  factory :simple_movement do
    name { "MyString" }
    value { "9.99" }
    date { "2020-09-27" }
    account_id {  create(:account).id }
    category_id {  create(:category).id }
  
    trait :income do
      simple_movement_type { 0 }
    end

    trait :expense do
      simple_movement_type { 10 }
    end
  end
end
