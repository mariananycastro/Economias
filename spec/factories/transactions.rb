FactoryBot.define do
  factory :transaction do
    name { "MyString" }
    value { "9.99" }
    date { "2020-09-27" }
    type { 1 }
  end
end
