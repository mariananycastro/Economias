# frozen_string_literal: true

feature 'installment' do
  before do
    create(:account, name: 'CC Nu')
    create(:category, name: 'Mercado')
  end

  describe 'user creates a installment and movements' do
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
end
