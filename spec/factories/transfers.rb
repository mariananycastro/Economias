FactoryBot.define do
  factory :transfer do
    transient do
      origin { build {:movement} }
      destiny { build {:movement} }
    end
  end
end
