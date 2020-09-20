# frozen_string_literal: true

# Categories used to classify account.
# Ex: Food, Transportation, Investiment, Health
class CategoriesController < ApplicationController
  def new
    @category = Category.new
  end
end
