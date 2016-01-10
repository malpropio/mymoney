require 'rails_helper'

RSpec.describe Debt, type: :model do
  it 'has a valid factory' do
    expect(FactoryGirl.build(:debt)).to be_valid
  end

  it 'is invalid without name' do
    debt = FactoryGirl.build(:debt, name: nil)
    expect(debt).to_not be_valid
    expect(debt.errors).to have_key(:name)
  end

  it 'is invalid without category' do
    debt = FactoryGirl.build(:debt, category: nil)
    expect(debt).to_not be_valid
    expect(debt.errors).to have_key(:category)
  end

  it 'is invalid without an account' do
    debt = FactoryGirl.build(:debt, account: nil)
    expect(debt).to_not be_valid
    expect(debt.errors).to have_key(:account)
  end

  it 'has autopay by default to be false' do
    debt = FactoryGirl.build(:debt)
    expect(debt.autopay).to be false
  end

  it 'is unique per user' do
    random_id = 323
    user1 = FactoryGirl.build(:user, id: random_id)
    category1 = FactoryGirl.build(:category, user: user1)
    account1 = FactoryGirl.build(:account, user: user1)
    debt_1 = FactoryGirl.create(:debt, category: category1, account: account1)
    debt_2 = FactoryGirl.build(:debt, category: category1, account: account1, name: debt_1.name)

    expect(debt_2).to_not be_valid
  end

  it 'has a fix amount present and payment start date' do
    amount = '29.99'
    debt = FactoryGirl.build(:debt, fix_amount: amount)
    expect(debt.payment_start_date).to_not be nil
  end

  it 'has a fix amount present and schedule present' do
    amount = '329.99'
    debt = FactoryGirl.build(:debt, fix_amount: amount)
    expect(debt.schedule).to_not be nil
  end

  it 'has many debt balances' do
    debt = FactoryGirl.create(:debt_with_debt_balances)
    expect(debt.debt_balances.length).to eq(1)
  end
end
