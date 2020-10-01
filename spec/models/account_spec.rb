RSpec.describe Account, type: :model do
  describe '#new' do
    let(:account_type) { create(:account_type) }

    context 'successfully' do
      subject { build(:account, name: 'CC Nu', active: true, initial_value: 1.34, expiration_type: 10, account_type: account_type ).valid?}

      it {is_expected.to eq true}
    end

    context 'failed' do
      subject { build(:account, name: '', active: '', initial_value: '', expiration_type: '' ) }

      it 'should raise error' do
        subject.valid?

        expect(subject.errors.count).to eq 3
        expect(subject.errors[:name]).to include("can't be blank")
        expect(subject.errors[:expiration_type]).to include("can't be blank")
        expect(subject.errors[:account_type]).to include("must exist")
      end
    end
  end

  describe '#create' do
    context 'successfully' do
      let(:account_type) { create(:account_type) }
      subject { create(:account, name: 'CC Nu', active: '', initial_value: '', expiration_type: 10, account_type: account_type ) }

      it 'should create an account' do
        expect(subject.name).to eq "CC Nu"
        expect(subject.active).to eq true
        expect(subject.initial_value).to eq 0
        expect(subject.expiration_type).to eq 'medium'
        expect(subject.account_type).to be account_type
        expect(Account.count).to eq 1
      end
    end

    context 'has unique name' do
      let(:account_type) { create(:account_type) }
      let(:account) { create(:account, name: 'CC Nu', account_type: account_type) }

      it 'should create an account' do
        account

        new_account = build(:account, name: 'CC Nu', account_type: account_type)
        new_account.valid?

        expect(new_account.errors[:name]).to include("has already been taken")
        expect(Account.first).to eq account
        expect(Account.all.count).to eq 1
      end
    end
  end
end
