# frozen_string_literal: true

FactoryBot.define do
  factory :account do
    name { 'CC Nu'}
    active { true }
    initial_value { 0.00 }
    account_type_id { create(:account_type).id }

    trait :dont_have do 
      expiration_type { 0 }
    end

    trait :short do 
      expiration_type { 10 }
    end

    trait :medium do 
      expiration_type { 20 }
    end

    trait :long do 
      expiration_type { 30 }
    end
  end
end
