# frozen_string_literal: true

# Categories used to classify account.
# Ex: Food, Transportation, Investiment, Health

#  add error
class Api::V1::CategoriesController < Api::V1::ApiController
  def index
    categories = categories_ordered
    render json: categories 
  end

  def create
    category = Category.create(params_category)
    render json: category
  end

  def update
    category.update(params_category)

    render json: category
  end

  def destroy
    category.destroy
  end

  private

  def params_category
    params.require(:category).permit(:name)
  end

  def categories_ordered
    Category.all.order(:name)
  end

  def category
    Category.find(params[:id])
  end
end
