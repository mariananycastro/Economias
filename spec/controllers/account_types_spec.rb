# frozen_string_literal: true

RSpec.describe AccountTypesController, type: :controller do
  describe '#new' do
    it 'renders the new template' do
      get :new

      expect(response).to render_template('new')
    end
  end

  describe '#create' do
    it 'creates an account type' do
      params_account_types = { account_type: { name: 'CC Nu' } }

      post :create, params: params_account_types

      expect(response).to redirect_to(root_path)
      expect(AccountType.count).to eq 1
    end

    it 'doesnt create an account type' do
      params_account_types = { account_type: { name: nil } }

      post :create, params: params_account_types

      expect(response).to render_template('new')
      expect(Account.count).to eq 0
    end
  end

  describe '#edit' do
    let(:account_type) { create(:account_type) }

    it 'renders the edit template' do
      get :edit, params: { id:  account_type.id }

      expect(response).to render_template('edit')
    end
  end

  describe '#update' do
    let(:account_type) { create(:account_type, name: 'CC Nu') }

    it 'sucessfully' do
      params_account_types = { name: 'CC BB' }

      put :update, params: { id: account_type.id , account_type: params_account_types }
      account_type_updated = AccountType.first

      expect(AccountType.count).to eq 1
      expect(account_type_updated.id).to eq account_type.id
      expect(account_type_updated.name).to eq 'CC BB'
    end

    it 'fails' do
      params_account_types = { name: nil }

      put :update, params: { id: account_type.id , account_type: params_account_types }
      account_type_updated = AccountType.first

      expect(AccountType.count).to eq 1
      expect(account_type_updated.id).to eq account_type.id
      expect(account_type_updated.name).to eq 'CC Nu'
    end
  end

  describe '#destroy' do
    let(:account_type) { create(:account_type) }

    it 'sucessfully' do
      get :destroy, params: { id:  account_type.id }

      expect(response).to redirect_to(root_path)
      expect(AccountType.count).to eq 0
    end
  end
end