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

      fill_in 'Nome:', with: 'Supermercado X'
      fill_in 'Valor:', with: 10.00
      fill_in 'Data:', with: Date.today
      select 'Despesa', from: 'Tipo:'
      select 'CC Nu', from: 'Conta:'
      select 'Mercado', from: 'Categoria:'
      click_on 'Salvar'

      new_movement_account = Movement.first.account.name
      new_movement_category = Movement.first.category.name

      expect(Movement.count).to eq 1
      expect(Movement.first.name).to eq 'Supermercado X'
      expect(Movement.first.value).to eq 10
      expect(Movement.first.date).to eq Date.today
      expect(Movement.first.movement_type).to eq 'expense'
      expect(new_movement_account).to eq 'CC Nu'
      expect(new_movement_category).to eq 'Mercado' 
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
      create(:account, name: 'CC BB')
      create(:category, name: 'Saude')
    end

    scenario 'successfully' do
      visit root_path
      click_on 'Criar Transação'
      click_on 'Editar'

      fill_in 'Nome:', with: 'Farmácia X'
      fill_in 'Valor:', with: 20.00
      fill_in 'Data:', with: Date.today - 1.day
      select 'Receita', from: 'Tipo:'
      select 'CC BB', from: 'Conta:'
      select 'Saude', from: 'Categoria:'
      click_on 'Salvar'

      new_movement_account = Movement.first.account.name
      new_movement_category = Movement.first.category.name

      expect(Movement.count).to eq 1
      expect(Movement.first.name).to eq 'Farmácia X'
      expect(Movement.first.value).to eq 20
      expect(Movement.first.date).to eq Date.today - 1.day
      expect(Movement.first.movement_type).to eq 'income'
      expect(new_movement_account).to eq 'CC BB'
      expect(new_movement_category).to eq 'Saude' 
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
