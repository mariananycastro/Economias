RSpec.describe AccountType, type: :model do
  describe '#new' do
    context 'sucessfully' do
      subject { build(:account_type, name: 'Checking Account').valid?  }

      it {is_expected.to eq true}
    end

    context 'failed' do
      subject { build(:account_type, name: '').valid? }

      it {is_expected.to eq false}
    end
  end

  describe '#create' do
    context 'sucessfully' do
      subject { create(:account_type, name: 'Checking Account') }

      it "should create account_type" do
        expect(subject.name).to eq 'Checking Account'
        expect(AccountType.count).to eq 1
      end
    end

    context 'failed' do
      context 'because its not unique' do
        let(:account_type) { create(:account_type, name: 'Checking Account') }
        subject { build(:account_type, name: 'Checking Account') }
        
        it "return error already been taken" do
          account_type

          subject.valid?

          expect(subject.errors[:name].pop).to eq "has already been taken"
          expect(AccountType.first.name).to eq "Checking Account"
          expect(AccountType.count).to eq 1
        end
      end
      
      context 'because its empty' do
        let(:account_type) { create(:account_type, name: 'Checking Account') }
        subject { build(:account_type, name: '' ) }
        it "returns cant be blank" do
          account_type
          
          subject.valid?
          
          expect(subject.errors[:name].pop).to eq "can't be blank"
          expect(AccountType.first.name).to eq "Checking Account"
          expect(AccountType.count).to eq 1
        end
      end
    end
  end

  describe '#edit' do
    subject { create(:account_type, name: 'Checking Account') }
    
    context 'sucessfully' do
      it 'should update account_type' do
        subject.update(name: 'Investiment')

        expect(subject.name).to eq 'Investiment'
        expect(AccountType.count).to eq 1
      end
    end

    context 'failed' do
      let(:account_type) { create(:account_type, name: 'Investiment')}

      it "because it has to be unique" do
        account_type
        subject.update(name: 'Investiment')
        
        subject.valid?

        expect(subject.errors[:name].pop).to eq "has already been taken"
        expect(AccountType.count).to eq 2
        expect(AccountType.first.name).to eq 'Investiment'
        expect(AccountType.last.name).to eq 'Checking Account'
      end

      it "because it has to be unique" do
        subject.update(name: '')
        
        subject.valid?

        expect(subject.errors[:name].pop).to eq "can't be blank"
        expect(AccountType.count).to eq 1
        expect(AccountType.first.name).to eq 'Checking Account'
      end
    end
  end

end
