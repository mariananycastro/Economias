class Transfer < ApplicationRecord
  belongs_to :origin, class_name: 'Transaction'
  belongs_to :destiny, class_name: 'Transaction'
  has_many :transactions
end
