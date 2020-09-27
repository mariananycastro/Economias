class ExpirationType < ApplicationRecord
  has_many :accounts

  enum period: { dont_have: 0, short: 10, medium: 20, long: 30 }
end
