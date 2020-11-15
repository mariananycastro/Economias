# frozen_string_literal: true

feature 'movement' do
  before do
    create(:account, name: 'CC Nu')
    create(:category, name: 'Mercado')
  end

  describe 'user creates a movement' do
    scenario 'successfully' do
      visit root_path

      click_on 'Criar Transação'

      within('div#movement') do
        fill_in 'Nome:', with: 'Supermercado X'
        fill_in 'Valor:', with: 10.00
        fill_in 'Data:', with: Date.today
        select 'Despesa', from: 'Tipo:'
        select 'CC Nu', from: 'Conta:'
        select 'Mercado', from: 'Categoria:'
        click_on 'Salvar'
      end

      expect(Movement.count).to eq 1
      expect(Movement.first.name).to eq('Supermercado X')
    end
  end

  describe 'user edits a movement' do
    before do
      create(:movement, name: 'Supermercado X',
                        value: 10,
                        date: Date.today,
                        movement_type: 'expense',
                        account_id: Account.first.id,
                        category_id: Category.first.id )
    end

    scenario 'successfully' do
      visit root_path
      click_on 'Criar Transação'
      click_on 'Editar'

      within('div#movement') do
        fill_in 'Nome:', with: 'Farmácia X'
        fill_in 'Valor:', with: 20.00
        fill_in 'Data:', with: Date.today - 1.day
        select 'Receita', from: 'Tipo:'
        click_on 'Salvar'
      end

      expect(Movement.count).to eq 1
    end
  end

  describe 'user delets a movement' do
    before do
      create(:movement, name: 'Supermercado X',
                        value: 10,
                        date: Date.today,
                        movement_type: 'expense',
                        account_id: Account.first.id,
                        category_id: Category.first.id )
    end

    scenario 'successfully' do
      visit root_path
      click_on 'Criar Transação'
      click_on 'Deletar'

      expect(Movement.count).to eq 0
    end
  end
end
