# frozen_string_literal: true

# Categories used to classify account.
# Ex: Food, Transportation, Investiment, Health
class CategoriesController < ApplicationController
  def new
    @category = Category.new
    @categories = categories_ordered
  end

  def create
    @category = Category.new(params_category)
    return redirect_to root_path if @category.save

    render :new
  end

  def edit
    @category = category
    @categories = categories_ordered
  end

  def update
    @category = category
    return redirect_to root_path if @category.update(params_category)

    render :edit
  end

  def destroy
    @category = category
    return redirect_to root_path if @category.destroy

    render :new
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
