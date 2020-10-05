# frozen_string_literal: true

RSpec.describe CategoriesController, type: :controller do
  describe '#new' do
    it 'renders the new template' do
      get :new

      expect(response).to render_template('new')
    end
  end

  describe '#create' do
    it 'creates a category' do
      category = { category: { name: 'Health' } }

      post :create, params: category

      expect(response).to redirect_to(root_path)
      expect(Category.count).to eq 1
    end

    it 'doesnt create a category' do
      category = { category: { name: nil } }

      post :create, params: category

      expect(response).to render_template('new')
      expect(Category.count).to eq 0
    end
  end

  describe '#edit' do
    let(:category) { create(:category) }

    it 'renders the edit template' do
      get :edit, params: { id:  category.id }

      expect(response).to render_template('edit')
    end
  end

  describe '#update' do
    let(:category) { create(:category, name: 'Health') }

    it 'sucessfully' do
      params_category = { name: 'Transportation' }

      put :update, params: { id: category.id , category: params_category }
      category_updated = Category.first

      expect(Category.count).to eq 1
      expect(category_updated.id).to eq category.id
      expect(category_updated.name).to eq 'Transportation'
    end

    it 'fails' do
      params_category = { name: nil }

      put :update, params: { id: category.id , category: params_category }
      category_updated = Category.first

      expect(Category.count).to eq 1
      expect(category_updated.id).to eq category.id
      expect(category_updated.name).to eq 'Health'
    end
  end

  describe '#destroy' do
    let(:category) { create(:category) }

    it 'sucessfully' do
      get :destroy, params: { id:  category.id }

      expect(response).to redirect_to(root_path)
      expect(Category.count).to eq 0
    end
  end
end