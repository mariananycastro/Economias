# frozen_string_literal: true

feature 'transfer' do
  describe 'user creates a transfer' do
    before do
      create(:account, name: 'CC Nu')
      create(:account, name: 'CC BB')
      create(:category, name: 'Mercado')
    end

    scenario 'successfully' do
      visit root_path

      click_on 'Criar Transferencia'

      fill_in 'Nome:', with: 'Supermercado X'
      fill_in 'Valor:', with: 10.00
      fill_in 'Data:', with: Date.today
      select 'Mercado', from: 'Categoria:'
      select 'CC Nu', from: 'Conta origem:'
      select 'CC BB', from: 'Conta destino:'
      click_on 'Salvar'

      origin = Movement.first
      destiny = Movement.second
      
      movement_category = origin.category.name

      expect(Movement.count).to eq 2
      Movement.all.map do |mov|
        expect(mov.name).to eq 'Supermercado X'
        expect(mov.value).to eq 10
        expect(mov.date).to eq Date.today
      end
      expect(origin.category_id).to eq destiny.category_id 
      expect(movement_category).to eq 'Mercado'

      expect(origin.movement_type).to eq 'expense'
      expect(destiny.movement_type).to eq 'income'

      expect(origin.account.name).to eq 'CC Nu'
      expect(destiny.account.name).to eq 'CC BB'

      expect(Transfer.count).to eq 1
      expect(Transfer.first.origin_id).to eq origin.id
      expect(Transfer.first.destiny_id).to eq destiny.id
    end
  end

  describe 'user edits a transfer ans its movements' do
    before do
      accountNu = create(:account, name: 'CC Nu')
      accountBB = create(:account, name: 'CC BB')
      category_mercado = create(:category, name: 'Mercado')
      create(:category, name: 'Saude')

      mov1 = create(:movement, name: 'Supermercado X',
                        value: 10,
                        date: Date.today,
                        movement_type: 'expense',
                        account_id: accountNu.id,
                        category_id: category_mercado.id )

      mov2 = create(:movement, name: 'Supermercado X',
                        value: 10,
                        date: Date.today,
                        movement_type: 'income',
                        account_id: accountBB.id,
                        category_id: category_mercado.id )

      create(:transfer, origin_id: mov1.id, destiny_id: mov2.id)
    end
    scenario 'successfully' do
      visit root_path
      click_on 'Criar Transação'
      click_link('Editar', match: :first)

      fill_in 'Nome:', with: 'Farmácia X'
      fill_in 'Valor:', with: 20.00
      fill_in 'Data:', with: Date.today - 1.day
      select 'Saude', from: 'Categoria:'
      select 'CC BB', from: 'Conta origem:'
      select 'CC Nu', from: 'Conta destino:'
      click_on 'Salvar'

      first_movement = Movement.first
      second_movement = Movement.second
      transfer = Transfer.first

      movement_category = first_movement.category.name

      expect(Transfer.count).to eq 1
      expect(transfer.origin_id).to eq first_movement.id
      expect(transfer.destiny_id).to eq second_movement.id

      expect(Movement.count).to eq 2
      Movement.all.map do |mov|
        expect(mov.name).to eq 'Farmácia X'
        expect(mov.value).to eq 20
        expect(mov.date).to eq Date.today - 1.day
      end
      expect(first_movement.category_id).to eq second_movement.category_id 
      expect(movement_category).to eq 'Saude'

      expect(first_movement.movement_type).to eq 'expense'
      expect(second_movement.movement_type).to eq 'income'

      expect(first_movement.account.name).to eq 'CC BB'
      expect(second_movement.account.name).to eq 'CC Nu'
    end
  end

  describe 'user delets a movement' do
    before do
      accountNu = create(:account, name: 'CC Nu')
      accountBB = create(:account, name: 'CC BB')
      category_mercado = create(:category, name: 'Mercado')

      mov1 = create(:movement, name: 'Supermercado X',
                        value: 10,
                        date: Date.today,
                        movement_type: 'expense',
                        account_id: accountNu.id,
                        category_id: category_mercado.id )

      mov2 = create(:movement, name: 'Supermercado X',
                        value: 10,
                        date: Date.today,
                        movement_type: 'income',
                        account_id: accountBB.id,
                        category_id: category_mercado.id )

      create(:transfer, origin_id: mov1.id, destiny_id: mov2.id)
    end

    scenario 'successfully' do
      visit root_path
      click_on 'Criar Transação'
      click_link('Deletar', match: :first)

      expect(Movement.count).to eq 0
      expect(Transfer.count).to eq 0
    end
  end
end


