# frozen_string_literal: true

RSpec.describe AccountsController, type: :controller do
  describe '#new' do
    it 'renders the new template' do
      get :new

      expect(response).to render_template('new')
    end
  end

  describe '#create' do
    let(:account_type) { create(:account_type) }
    it 'creates an account' do
      params_account = {
        account: {
          name: 'CC Nu', 
          active: true, initial_value: '0.0',
          account_type_id: account_type.id,
          expiration_type: 'short'
        }
      }

      post :create, params: params_account

      expect(response).to redirect_to(root_path)
      expect(Account.count).to eq 1
    end

    it 'doesnt create an account' do
      params_account = {
        account: {
          name: nil,
          active: nil,
          initial_value: nil,
          account_type_id: nil,
          expiration_type: nil
        }
      }

      post :create, params: params_account

      expect(response).to render_template('new')
      expect(Account.count).to eq 0
    end
  end

  describe '#edit' do
    let(:account) { create(:account) }

    it 'renders the edit template' do
      get :edit, params: { id:  account.id }

      expect(response).to render_template('edit')
    end
  end

  describe '#update' do
    let(:account) { create(:account,
                            name: 'CC Nu',
                            active: true,
                            initial_value: 1.00,
                            expiration_type: 'short'
                          )
                  }
    let(:account_type) { create(:account_type, name: 'Investimento')}

    it 'sucessfully' do
      params_account = {
        name: 'Poupança',
        active: false,
        initial_value: 200,
        account_type_id: account_type.id,
        expiration_type: 'medium'
      }

      put :update, params: { id: account.id , account: params_account }
      account_updated = Account.first

      expect(Account.count).to eq 1
      expect(account_updated.id).to eq account.id
      expect(account_updated.name).to eq 'Poupança'
      expect(account_updated.active).to eq false
      expect(account_updated.initial_value).to eq 200
      expect(account_updated.account_type.name).to eq 'Investimento'
      expect(account_updated.expiration_type).to eq 'medium'
    end

    it 'fails' do
      params_account = {
        name: nil,
        active: nil,
        initial_value: nil,
        account_type_id: nil,
        expiration_type: nil
      }

      put :update, params: { id: account.id , account: params_account }
      account_updated = Account.first

      expect(Account.count).to eq 1
      expect(account_updated.id).to eq account.id
      expect(account_updated.name).to eq 'CC Nu'
      expect(account_updated.active).to eq true
      expect(account_updated.initial_value).to eq 1.00
      expect(account_updated.expiration_type).to eq 'short'
    end
  end

  describe '#destroy' do
    let(:account) { create(:account) }

    it 'sucessfully' do
      get :destroy, params: { id:  account.id }

      expect(response).to redirect_to(root_path)
      expect(Account.count).to eq 0
    end
  end
end