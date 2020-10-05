# frozen_string_literal: true

RSpec.describe AccountDecorator do
  describe 'decorates an account' do
    let(:account_type) { create(:account_type, name: 'Checking Account') }
    let(:account) { build_stubbed(:account, account_type_id: account_type.id).decorate }
    # let(:account) { FactoryBot.build_stubbed(:account) }

    it 'returns the displayed days' do
      expect(account.account_type_name).to eq('Checking Account')
      expect(account.expiration_names).to eq([['Curto', 'short'], ['Médio', 'medium'], ['Longo', 'long']])
    end
  end
end
