# frozen_string_literal: true

feature 'installment' do
  describe 'user creates a installment and movements' do
    before do
      create(:account, name: 'CC Nu')
      create(:category, name: 'Mercado')
    end

    scenario 'successfully' do
      visit root_path

      click_on 'Criar Parcelamento'

      fill_in 'Nome:', with: 'Supermercado X'
      fill_in 'Valor Total:', with: 10.00
      select 'Despesa', from: 'Tipo:'
      select 'Mercado', from: 'Categoria:'
      select 'CC Nu', from: 'Conta:'
      fill_in 'Data Inicial:', with: Date.today
      fill_in 'Qtd Parcelas:', with: 2
      select 'Mensal', from: 'Intervalo entre parcelas:'
      click_on 'Salvar'

      expect(Movement.count).to eq 2
      expect(Movement.first.name).to eq 'Supermercado X (1 de 2)'
      expect(Movement.second.name).to eq 'Supermercado X (2 de 2)'

      Movement.all.each do |mov|
        expect(mov.value).to eq 5
        expect(mov.movement_type).to eq 'expense'
        expect(mov.category.name).to eq 'Mercado'
        expect(mov.account.name).to eq 'CC Nu'
      end

      expect(Movement.first.date).to eq Date.today
      expect(Movement.second.date).to eq Date.today + 1.month

      expect(Installment.count).to eq 1
      expect(Installment.first.qtd).to eq 2
      expect(Installment.first.interval).to eq 'monthly'
      expect(Installment.first.initial_date).to eq Date.today

      expect(InstallmentMovement.count).to eq 2
      expect(InstallmentMovement.first.installment).to eq Installment.first
      expect(InstallmentMovement.last.installment).to eq Installment.first
      expect(InstallmentMovement.first.movement).to eq Movement.first
      expect(InstallmentMovement.last.movement).to eq Movement.second
    end
  end

  describe 'user updates a installment and movements' do
    let(:accountNu) { create(:account, name: 'CC Nu bank') }
    let(:accountBB) { create(:account, name: 'CC BB') }
    let(:category_mercado) { create(:category, name: 'Supermercado') }
    let(:category_saude) { create(:category, name: 'Saude') }

    let(:mov1) { create(:movement, name: 'Supermercado X (1 x 2)',
                                   value: 10,
                                   date: Date.today,
                                   movement_type: 'expense',
                                   account_id: accountNu.id,
                                   category_id: category_mercado.id ) }

    let(:mov2) { create(:movement, name: 'Supermercado X (2 x 2)',
                                   value: 10,
                                   date: Date.today + 1.month,
                                   movement_type: 'expense',
                                   account_id: accountNu.id,
                                   category_id: category_mercado.id ) }

    let(:installment) { create(:installment, comum_name: 'Supermercado X', qtd: 2, interval: 'monthly', initial_date: Date.today) }
    let(:installment_mov1) { create(:installment_movement, installment: installment, movement: mov1, altered: false) }
    let(:installment_mov2) { create(:installment_movement, installment: installment, movement: mov2, altered: false) }
    
    scenario 'change all attributes except qtd installment' do
      accountNu
      accountBB
      category_mercado
      category_saude
      mov1
      mov2
      installment
      installment_mov1
      installment_mov2

      visit root_path
      click_on 'Criar Transação'
      click_link('Editar Parcelamento', match: :first)
      fill_in 'Nome:', with: 'Farmácia X'
      fill_in 'Valor Total:', with: 20.00
      select 'Receita', from: 'Tipo:'
      select 'Saude', from: 'Categoria:'
      select 'CC BB', from: 'Conta:'
      fill_in 'Data Inicial:', with: Date.today + 1.day
      fill_in 'Qtd Parcelas:', with: 2
      select 'Diaria', from: 'Intervalo entre parcelas:'
      click_on 'Salvar'

      new_initial_date = Date.today + 1.day

      expect(Movement.count).to eq 2
      expect(Movement.first.name).to eq 'Farmácia X (1 de 2)'
      expect(Movement.second.name).to eq 'Farmácia X (2 de 2)'

      Movement.all.each do |mov|
        expect(mov.value).to eq 10
        expect(mov.movement_type).to eq 'income'
        expect(mov.category.name).to eq 'Saude'
        expect(mov.account.name).to eq 'CC BB'
      end

      expect(Movement.first.date).to eq new_initial_date
      expect(Movement.second.date).to eq new_initial_date + 1.day

      expect(Installment.count).to eq 1
      expect(Installment.first.qtd).to eq 2
      expect(Installment.first.comum_name).to eq 'Farmácia X'
      expect(Installment.first.interval).to eq 'daily'
      expect(Installment.first.initial_date).to eq new_initial_date

      expect(InstallmentMovement.count).to eq 2
      expect(InstallmentMovement.first.installment).to eq Installment.first
      expect(InstallmentMovement.second.installment).to eq Installment.first

      expect(InstallmentMovement.first.movement).to eq Movement.first
      expect(InstallmentMovement.second.movement).to eq Movement.second
    end

    scenario 'increase installment qtd' do
      accountNu
      category_mercado
      mov1
      mov2
      installment
      installment_mov1
      installment_mov2

      visit root_path
      click_on 'Criar Transação'
      click_link('Editar Parcelamento', match: :first)
      fill_in 'Qtd Parcelas:', with: 3
      click_on 'Salvar'

      expect(Movement.count).to eq 3
      expect(Installment.count).to eq 1
      expect(Installment.first.qtd).to eq 3

      expect(InstallmentMovement.count).to eq 3
      expect(InstallmentMovement.first.installment).to eq Installment.first
      expect(InstallmentMovement.second.installment).to eq Installment.first
      expect(InstallmentMovement.last.installment).to eq Installment.first

      expect(InstallmentMovement.first.movement).to eq Movement.first
      expect(InstallmentMovement.second.movement).to eq Movement.second
      expect(InstallmentMovement.last.movement).to eq Movement.last
    end

    scenario 'decrease installment qtd' do
      accountNu
      category_mercado
      mov1
      mov2
      installment
      installment_mov1
      installment_mov2

      mov3 = create(:movement, name: 'Supermercado X (3 x 3)',
                               value: 10,
                               date: Date.today + 2.month,
                               movement_type: 'expense',
                               account_id: accountNu.id,
                               category_id: category_mercado.id )

      installment_mov3 = create(:installment_movement, installment: installment, movement: mov3, altered: false)
      installment.update(qtd: 3)

      visit root_path
      click_on 'Criar Transação'
      click_link('Editar Parcelamento', match: :first)
      fill_in 'Qtd Parcelas:', with: 2
      click_on 'Salvar'

      expect(Movement.count).to eq 2
      expect(Installment.count).to eq 1
      expect(Installment.first.qtd).to eq 2
      expect(InstallmentMovement.count).to eq 2
    end
  end

  describe 'user deletes' do
    let(:accountNu) { create(:account, name: 'CC Nu bank') }
    let(:category_mercado) { create(:category, name: 'Supermercado') }

    let(:mov1) { create(:movement, name: 'Supermercado X (1 x 2)',
                                   value: 10,
                                   date: Date.today,
                                   movement_type: 'expense',
                                   account_id: accountNu.id,
                                   category_id: category_mercado.id ) }

    let(:mov2) { create(:movement, name: 'Supermercado X (2 x 2)',
                                   value: 10,
                                   date: Date.today + 1.month,
                                   movement_type: 'expense',
                                   account_id: accountNu.id,
                                   category_id: category_mercado.id ) }

    let(:installment) { create(:installment, comum_name: 'Supermercado X', qtd: 2, interval: 'monthly', initial_date: Date.today) }
    let(:installment_mov1) { create(:installment_movement, installment: installment, movement: mov1, altered: false) }
    let(:installment_mov2) { create(:installment_movement, installment: installment, movement: mov2, altered: false) }
    
    scenario 'a installment and its movements' do
      accountNu
      category_mercado
      mov1
      mov2
      installment
      installment_mov1
      installment_mov2

      visit root_path
      click_on 'Criar Transação'
      click_link('Deletar Parcelamento', match: :first)

      expect(Movement.count).to eq 0
      expect(Installment.count).to eq 0
      expect(InstallmentMovement.count).to eq 0
    end

    scenario 'only one movement' do
      accountNu
      category_mercado
      mov1
      mov2
      installment
      installment_mov1
      installment_mov2

      visit root_path
      click_on 'Criar Transação'
      click_link('Deletar', match: :first)

      expect(Movement.count).to eq 1
      expect(Installment.count).to eq 1
      expect(Installment.first.qtd).to eq 1
      expect(Installment.first.initial_date).to eq mov2.date
      expect(InstallmentMovement.count).to eq 1
    end
  end

  describe 'user updates one movement of an installment' do
    let(:accountNu) { create(:account, name: 'CC Nu bank') }
    let(:accountBB) { create(:account, name: 'CC BB') }
    let(:category_mercado) { create(:category, name: 'Supermercado') }
    let(:category_saude) { create(:category, name: 'Saude') }

    let(:mov1) { create(:movement, name: 'Supermercado X (1 x 2)',
                                   value: 10,
                                   date: Date.today,
                                   movement_type: 'expense',
                                   account_id: accountNu.id,
                                   category_id: category_mercado.id ) }

    let(:mov2) { create(:movement, name: 'Supermercado X (2 x 2)',
                                   value: 10,
                                   date: Date.today + 1.month,
                                   movement_type: 'expense',
                                   account_id: accountNu.id,
                                   category_id: category_mercado.id ) }

    let(:installment) { create(:installment, comum_name: 'Supermercado X', qtd: 2, interval: 'monthly', initial_date: Date.today) }
    let(:installment_mov1) { create(:installment_movement, installment: installment, movement: mov1, altered: false) }
    let(:installment_mov2) { create(:installment_movement, installment: installment, movement: mov2, altered: false) }
    
    scenario 'successfully' do
      accountNu
      accountBB
      category_mercado
      category_saude
      mov1
      mov2
      installment
      installment_mov1
      installment_mov2

      visit root_path
      click_on 'Criar Transação'
      click_link('Editar', match: :first)
      fill_in 'Nome:', with: 'Farmácia X'
      fill_in 'Valor:', with: 50.00
      select 'Receita', from: 'Tipo:'
      select 'Saude', from: 'Categoria:'
      select 'CC BB', from: 'Conta:'
      fill_in 'Data:', with: (Date.today + 1.day)
      click_on 'Salvar'

      expect(Movement.count).to eq 2
      expect(Movement.first.name).to eq 'Farmácia X'
      expect(Movement.first.value).to eq 50
      expect(Movement.first.movement_type).to eq 'income'
      expect(Movement.first.category.name).to eq 'Saude'
      expect(Movement.first.account.name).to eq 'CC BB'
      expect(Movement.first.date).to eq Date.today + 1.day

      expect(Movement.second.name).to eq 'Supermercado X (2 x 2)'
      expect(Movement.second.value).to eq 10
      expect(Movement.second.movement_type).to eq 'expense'
      expect(Movement.second.category.name).to eq 'Supermercado'
      expect(Movement.second.account.name).to eq 'CC Nu bank'
      expect(Movement.second.date).to eq Date.today + 1.month

      expect(Installment.count).to eq 1
      expect(Installment.first.qtd).to eq 2
      expect(Installment.first.interval).to eq 'monthly'
      expect(Installment.first.initial_date).to eq Date.today + 1.day

      expect(InstallmentMovement.count).to eq 2
      expect(InstallmentMovement.first.installment).to eq Installment.first
      expect(InstallmentMovement.last.installment).to eq Installment.first

      expect(InstallmentMovement.first.movement).to eq Movement.first
      expect(InstallmentMovement.last.movement).to eq Movement.second

      expect(InstallmentMovement.first.altered).to eq true
      expect(InstallmentMovement.last.altered).to eq false
    end
  end
end
