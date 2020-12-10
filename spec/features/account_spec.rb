# frozen_string_literal: true

feature 'category' do
  describe 'visite page new category' do
      let(:account_type) {create(:account_type, name: 'CC')}

    scenario 'successfully' do
      account_type
      visit root_path

      click_on 'Criar Conta'

      fill_in 'Nome:', with: 'Testes'
      fill_in 'Saldo Inicial:', with: 'Testes'
      select 'CC', from: 'Tipo de conta:'
      select 'Curto', from: 'Tipo Investimento:'
      click_on 'Salvar'

binding.pry
      expect(current_path).to eq("/categories/new")
      expect(page.body).to have_content('Nome:')
      expect(page.body).to have_button('Salvar')
    end
  end
end
