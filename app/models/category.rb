# frozen_string_literal: true

# categories of simple_movement. Ex: Transportation, Work, Home, Health
class Category < ApplicationRecord
  validates :name, presence: true
  validates :name, uniqueness: true
end
