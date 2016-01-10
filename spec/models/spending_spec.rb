require 'rails_helper'

RSpec.describe Spending, type: :model do
  it 'has a valid factory' do
    expect(FactoryGirl.build(:spending)).to be_valid
  end

  context 'is invalid when' do
    it 'amount is empty' do
      spending = FactoryGirl.build(:spending, amount: nil)
      expect(spending).to_not be_valid
      expect(spending.errors).to have_key(:amount)
    end

    it 'amount is 0' do
      spending = FactoryGirl.build(:spending, amount: 0)
      expect(spending).to_not be_valid
      expect(spending.errors).to have_key(:amount)
    end

    it 'description is empty' do
      spending = FactoryGirl.build(:spending, description: nil)
      expect(spending).to_not be_valid
      expect(spending.errors).to have_key(:description)
    end

    it 'spending date is empty' do
      spending = FactoryGirl.build(:spending, spending_date: nil)
      expect(spending).to_not be_valid
      expect(spending.errors).to have_key(:spending_date)
    end

    it 'budget is empty' do
      spending = FactoryGirl.build(:spending, budget: nil)
      expect(spending).to_not be_valid
      expect(spending.errors).to have_key(:budget)
    end

    it 'payment method is empty' do
      spending = FactoryGirl.build(:spending, payment_method: nil)
      expect(spending).to_not be_valid
      expect(spending.errors).to have_key(:payment_method)
    end

    it 'category has debts and debt balance is empty' do
      spending = FactoryGirl.build(:spending)
      spending.budget.category.debts << FactoryGirl.build(:debt)
      expect(spending).to_not be_valid
    end

    it "category and debt balance don't match" do
      spending = FactoryGirl.build(:spending)
      debt_balance_1 = FactoryGirl.create(:debt_balance)
      debt_balance_2 = FactoryGirl.create(:debt_balance)
      spending.budget.category.debts << debt_balance_1.debt
      spending.debt_balance_id = debt_balance_2.id
      expect(spending).to_not be_valid
    end
  end
end
