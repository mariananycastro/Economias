# frozen_string_literal: true

feature 'category' do
  describe 'visite page new category' do
    scenario 'successfully' do
      visit root_path

      click_on 'Criar Categoria'

      expect(current_path).to eq("/categories/new")
      expect(page.body).to have_content('Nome:')
      expect(page.body).to have_button('Salvar')
    end
  end

  describe 'creates category' do
    context 'new category path' do 
      scenario 'successfully' do
        visit new_category_path

        fill_in 'Nome:', with: 'Mercado'
        click_on 'Salvar'

        expect(Category.count).to eq(1)
        expect(Category.first.name).to eq('Mercado')
      end
    end

    context 'unsuccessfully' do
      let(:category) { create(:category, name: 'Saúde') }

      scenario 'name must be unique' do
        visit new_category_path

        fill_in 'Nome:', with: 'Saúde'
        click_on 'Salvar'

        expect(Category.count).to eq(1)
        expect(Category.first.name).to eq('Saúde')
      end
    end
  end

  describe 'edits category' do 
    let(:category) { create(:category, name: 'Saúde') }

    context 'successfully' do 
      scenario 'by link editar' do
        category
        visit  new_category_path

        click_on 'Editar'

        fill_in 'Nome:', with: 'Mercado'
        click_on 'Salvar'

        expect(Category.count).to eq(1)
        expect(Category.first.name).to eq('Mercado')
      end

      scenario 'category path' do
        visit edit_category_path(category.id)

        fill_in 'Nome:', with: 'Mercado'
        click_on 'Salvar'

        expect(Category.count).to eq(1)
        expect(Category.first.name).to eq('Mercado')
      end
    end

    context 'ununsuccessfully' do
      scenario 'name must exist' do
        visit edit_category_path(category.id)

        fill_in 'Nome:', with: ''
        click_on 'Salvar'

        expect(Category.count).to eq(1)
        expect(Category.first.name).to eq('Saúde')
      end
    end
  end
end