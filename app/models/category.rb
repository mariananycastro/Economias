# frozen_string_literal: true

# categories of transactions. Ex: Transportation, Work, Home, Health
class Category < ApplicationRecord
  validates :name, presence: true, uniqueness: true
end
