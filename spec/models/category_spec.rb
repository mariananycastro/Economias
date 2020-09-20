# frozen_string_literal: true

RSpec.describe Category, type: :model do
  describe '#new' do
    context 'sucessfully' do
      subject { build(:category, name: 'Grocery').valid?  }

      it {is_expected.to eq true}
    end

    context 'failed' do
      subject { build(:category, name: '').valid? }

      it {is_expected.to eq false}
    end
  end

  describe '#create' do
    context 'sucessfully' do
      subject { create(:category, name: 'Grocery') }

      it "should create category" do
        expect(subject.name).to eq 'Grocery'
        expect(Category.count).to eq 1
      end
    end

    context 'failed' do
      context 'because its not unique' do
        let(:category) { create(:category, name: 'Grocery') }
        subject { build(:category, name: 'Grocery') }
        
        it "return error already been taken" do
          category

          subject.valid?

          expect(subject.errors[:name].pop).to eq "has already been taken"
          expect(Category.first.name).to eq "Grocery"
          expect(Category.count).to eq 1
        end
      end
      
      context 'because its empty' do
        let(:category) { create(:category, name: 'Grocery') }
        subject { build(:category, name: '' ) }
        it "returns cant be blank" do
          category
          
          subject.valid?
          
          expect(subject.errors[:name].pop).to eq "can't be blank"
          expect(Category.first.name).to eq "Grocery"
          expect(Category.count).to eq 1
        end
      end
    end
  end

  describe '#edit' do
    subject { create(:category, name: 'Grocery') }
    
    context 'sucessfully' do
      it 'should update category' do
        subject.update(name: 'Health')

        expect(subject.name).to eq 'Health'
        expect(Category.count).to eq 1
      end
    end

    context 'failed' do
      let(:category) { create(:category, name: 'Health')}

      it "because it has to be unique" do
        category
        subject.update(name: 'Health')
        
        subject.valid?

        expect(subject.errors[:name].pop).to eq "has already been taken"
        expect(Category.count).to eq 2
        expect(Category.first.name).to eq 'Health'
        expect(Category.last.name).to eq 'Grocery'
      end

      it "because it has to be unique" do
        subject.update(name: '')
        
        subject.valid?

        expect(subject.errors[:name].pop).to eq "can't be blank"
        expect(Category.count).to eq 1
        expect(Category.first.name).to eq 'Grocery'
      end
    end
  end
end
