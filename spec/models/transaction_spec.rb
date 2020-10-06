# frozen_string_literal: true

RSpec.describe Transaction, type: :model do
  describe '#new' do
    let(:account) { create(:account) }
    let(:category) { create(:category) }

    context 'successfully' do
      subject { build(:transaction, name: 'Supermarket',
                                    value: 20.00,
                                    date: Date.today(),
                                    transaction_type: 0,
                                    account: account,
                                    category: category
              ).valid?}

      it { is_expected.to eq true }
    end

    context 'validates fields' do
      context 'presence' do
        subject { build(:transaction, name: nil,
                                      value: nil,
                                      date: nil,
                                      transaction_type: nil,
                                      account: nil,
                                      category: nil
                )}

        it 'fields should exist' do
          subject.valid?

          expect(subject.errors[:name]).to include "can't be blank"
          expect(subject.errors[:value]).to include "can't be blank"
          expect(subject.errors[:value]).to include 'is not a number'
          expect(subject.errors[:date]).to include "can't be blank"
          expect(subject.errors[:transaction_type]).to include "can't be blank"
          expect(subject.errors[:account]).to include "must exist"
          expect(subject.errors[:category]).to include "must exist"
        end
      end

      context 'value should be positive' do
        subject { build(:transaction, name: 'Supermarket',
                        value: -0.01,
                        date: Date.today(),
                        transaction_type: 0,
                        account: account,
                        category: category
                )}

        it 'raises error' do
          subject.valid?

          expect(subject.errors[:value]).to include "must be greater than or equal to 0.01"
        end
      end

      context 'value should greater or equal to 0.01' do
        subject { build(:transaction, name: 'Supermarket',
                        value: 0.00,
                        date: Date.today(),
                        transaction_type: 0,
                        account: account,
                        category: category
                )}

        it 'raises error' do
          subject.valid?

          expect(subject.errors[:value]).to include "must be greater than or equal to 0.01"
        end
      end
    end
  end
end
