require 'rails_helper'

RSpec.describe IncomeSource, type: :model do
  it 'has a valid factory' do
    expect(FactoryGirl.build(:income_source)).to be_valid
  end

  context 'is invalid when' do
    it "doesn't belong to an account" do
      income_source = FactoryGirl.build(:income_source, account: nil)
      expect(income_source).to_not be_valid
      expect(income_source.errors).to have_key(:account)
    end

    it 'amount is empty' do
      income_source = FactoryGirl.build(:income_source, amount: nil)
      expect(income_source).to_not be_valid
      expect(income_source.errors).to have_key(:amount)
    end

    it 'amount is not a number' do
      income_source = FactoryGirl.build(:income_source, amount: 'test')
      expect(income_source).to_not be_valid
      expect(income_source.errors).to have_key(:amount)
    end

    it 'end date is empty' do
      income_source = FactoryGirl.build(:income_source, end_date: nil)
      expect(income_source).to_not be_valid
      expect(income_source.errors).to have_key(:end_date)
    end

    it 'start date is empty' do
      income_source = FactoryGirl.build(:income_source, start_date: nil)
      expect(income_source).to_not be_valid
      expect(income_source.errors).to have_key(:start_date)
    end

    it 'name is empty' do
      income_source = FactoryGirl.build(:income_source, name: nil)
      expect(income_source).to_not be_valid
      expect(income_source.errors).to have_key(:name)
    end

    it 'pay day is empty' do
      income_source = FactoryGirl.build(:income_source, pay_day: nil)
      expect(income_source).to_not be_valid
      expect(income_source.errors).to have_key(:pay_day)
    end

    it 'pay schedule is empty' do
      income_source = FactoryGirl.build(:income_source, pay_schedule: nil)
      expect(income_source).to_not be_valid
      expect(income_source.errors).to have_key(:pay_schedule)
    end

    context 'weekly' do
      it 'pay day is not a day of the week' do
        income_source = FactoryGirl.build(:income_source, pay_day: 'test', pay_schedule: 'weekly')
        expect(income_source).to_not be_valid
      end

      it "pay day doesn't sync with start and end date" do
        income_source = FactoryGirl.build(:income_source, pay_day: 'monday', pay_schedule: 'weekly')
        expect(income_source).to_not be_valid
      end
    end

    context 'bi-weekly' do
      it 'pay day is not a day of the week' do
        income_source = FactoryGirl.build(:income_source, pay_day: 'test', pay_schedule: 'bi-weekly')
        expect(income_source).to_not be_valid
      end

      it "pay day doesn't sync with start and end date" do
        income_source = FactoryGirl.build(:income_source, pay_day: 'monday', pay_schedule: 'bi-weekly')
        expect(income_source).to_not be_valid
      end
    end

    context 'semi-monthly' do
      it "pay day doesn't contain 2 element" do
        income_source = FactoryGirl.build(:income_source, pay_day: '1', pay_schedule: 'semi-monthly')
        expect(income_source).to_not be_valid
        income_source = FactoryGirl.build(:income_source, pay_day: '1,2,3', pay_schedule: 'semi-monthly')
        expect(income_source).to_not be_valid
      end

      it 'at least one pay day is not 1-31, first, or last' do
        income_source = FactoryGirl.build(:income_source, pay_day: 'monday,first', pay_schedule: 'semi-monthly')
        expect(income_source).to_not be_valid
        income_source = FactoryGirl.build(:income_source, pay_day: '1,-2', pay_schedule: 'semi-monthly')
        expect(income_source).to_not be_valid
        income_source = FactoryGirl.build(:income_source, pay_day: 'last,33', pay_schedule: 'semi-monthly')
        expect(income_source).to_not be_valid
      end
    end
  end

  context 'returns the right number of paychecks' do
    it 'for weekly' do
      income_source = FactoryGirl.build(:income_source, start_date: '2014-01-03', end_date: '2017-01-06', pay_day: 'friday', pay_schedule: 'weekly')
      expect(income_source.paychecks(Date.new(2013, 1, 1), Date.new(2018, 1, 1)).size).to eq(158)
      expect(income_source.paychecks(Date.new(2015, 1, 1), Date.new(2016, 1, 1)).size).to eq(53)
    end

    it 'for bi-weekly' do
      income_source = FactoryGirl.build(:income_source, start_date: '2014-01-03', end_date: '2017-01-06', pay_day: 'friday', pay_schedule: 'bi-weekly')
      expect(income_source.paychecks(Date.new(2013, 1, 1), Date.new(2018, 1, 1)).size).to eq(79)
      expect(income_source.paychecks(Date.new(2015, 1, 1), Date.new(2016, 1, 1)).size).to eq(27)
    end

    it 'for semi-monthly' do
      income_source = FactoryGirl.build(:income_source, pay_day: '16,first', pay_schedule: 'semi-monthly', start_date: '2014-01-03', end_date: '2017-01-06')
      expect(income_source.paychecks(Date.new(2013, 1, 1), Date.new(2018, 1, 1)).size).to eq(72)
      expect(income_source.paychecks(Date.new(2015, 1, 1), Date.new(2016, 1, 1)).size).to eq(25)
    end

    it 'for total of multiple sources' do
      FactoryGirl.create(:income_source, start_date: '2014-01-03', end_date: '2017-01-06', pay_day: 'friday', pay_schedule: 'weekly')
      FactoryGirl.create(:income_source, start_date: '2014-01-03', end_date: '2017-01-06', pay_day: 'friday', pay_schedule: 'bi-weekly')
      FactoryGirl.create(:income_source, pay_day: '16,first', pay_schedule: 'semi-monthly', start_date: '2014-01-03', end_date: '2017-01-06')
      expect(IncomeSource.total_paychecks(nil, Date.new(2013, 1, 1), Date.new(2018, 1, 1))).to eq(220)
      expect(IncomeSource.total_paychecks(nil, Date.new(2015, 1, 1), Date.new(2016, 1, 1))).to eq(74)
    end

    it 'for total of multiple sources per account' do
      account = FactoryGirl.create(:account)
      FactoryGirl.create(:income_source, account: account, start_date: '2014-01-03', end_date: '2017-01-06', pay_day: 'friday', pay_schedule: 'weekly')
      FactoryGirl.create(:income_source, account: account, start_date: '2014-01-03', end_date: '2017-01-06', pay_day: 'friday', pay_schedule: 'bi-weekly')
      FactoryGirl.create(:income_source, pay_day: '16,first', pay_schedule: 'semi-monthly', start_date: '2014-01-03', end_date: '2017-01-06')
      expect(IncomeSource.total_paychecks(account, Date.new(2013, 1, 1), Date.new(2018, 1, 1))).to eq(158)
      expect(IncomeSource.total_paychecks(account, Date.new(2015, 1, 1), Date.new(2016, 1, 1))).to eq(53)
    end
  end

  context 'returns the right income amount' do
    it 'for weekly' do
      income_source = FactoryGirl.build(:income_source, start_date: '2014-01-03', end_date: '2017-01-06', pay_day: 'friday', pay_schedule: 'weekly')
      expect(income_source.income(Date.new(2013, 1, 1), Date.new(2018, 1, 1))).to eq(158_000)
      expect(income_source.income(Date.new(2015, 1, 1), Date.new(2016, 1, 1))).to eq(53_000)
    end

    it 'for bi-weekly' do
      income_source = FactoryGirl.build(:income_source, start_date: '2014-01-03', end_date: '2017-01-06', pay_day: 'friday', pay_schedule: 'bi-weekly')
      expect(income_source.income(Date.new(2013, 1, 1), Date.new(2018, 1, 1))).to eq(79_000)
      expect(income_source.income(Date.new(2015, 1, 1), Date.new(2016, 1, 1))).to eq(27_000)
    end

    it 'for semi-monthly' do
      income_source = FactoryGirl.build(:income_source, pay_day: '16,first', pay_schedule: 'semi-monthly', start_date: '2014-01-03', end_date: '2017-01-06')
      expect(income_source.income(Date.new(2013, 1, 1), Date.new(2018, 1, 1))).to eq(72_000)
      expect(income_source.income(Date.new(2015, 1, 1), Date.new(2016, 1, 1))).to eq(25_000)
    end

    it 'for total of multiple sources' do
      FactoryGirl.create(:income_source, start_date: '2014-01-03', end_date: '2017-01-06', pay_day: 'friday', pay_schedule: 'weekly')
      FactoryGirl.create(:income_source, start_date: '2014-01-03', end_date: '2017-01-06', pay_day: 'friday', pay_schedule: 'bi-weekly')
      FactoryGirl.create(:income_source, pay_day: '16,first', pay_schedule: 'semi-monthly', start_date: '2014-01-03', end_date: '2017-01-06')
      expect(IncomeSource.total_income(nil, Date.new(2013, 1, 1), Date.new(2018, 1, 1))).to eq(309_000)
      expect(IncomeSource.total_income(nil, Date.new(2015, 1, 1), Date.new(2016, 1, 1))).to eq(105_000)
    end

    it 'for total of multiple sources per account' do
      account = FactoryGirl.create(:account)
      FactoryGirl.create(:income_source, account: account, start_date: '2014-01-03', end_date: '2017-01-06', pay_day: 'friday', pay_schedule: 'weekly')
      FactoryGirl.create(:income_source, account: account, start_date: '2014-01-03', end_date: '2017-01-06', pay_day: 'friday', pay_schedule: 'bi-weekly')
      FactoryGirl.create(:income_source, pay_day: '16,first', pay_schedule: 'semi-monthly', start_date: '2014-01-03', end_date: '2017-01-06')
      expect(IncomeSource.total_income(account, Date.new(2013, 1, 1), Date.new(2018, 1, 1))).to eq(237_000)
      expect(IncomeSource.total_income(account, Date.new(2015, 1, 1), Date.new(2016, 1, 1))).to eq(80_000)
    end
  end
end
