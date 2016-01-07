require 'rails_helper'

RSpec.describe Debt, type: :model do
  it "has a valid factory" do
	expect(FactoryGirl.build(:debt1)).to be_valid
  end

  it "is invalid without name" do
	debt = FactoryGirl.build(:debt1, name: nil)
	expect(debt).to_not be_valid
	expect(debt.errors).to have_key(:name)
  end

  it "is invalid without category" do
	debt = FactoryGirl.build(:debt1, category: nil)
	expect(debt).to_not be_valid
	expect(debt.errors).to have_key(:category)
  end

  it "is invalid without an account" do
	debt = FactoryGirl.build(:debt1, account: nil)
	expect(debt).to_not be_valid
	expect(debt.errors).to have_key(:account)
  end

  it "has autopay by default to be false" do
	debt = FactoryGirl.build(:debt1)
	expect(debt.autopay).to be false
  end
  
  it "is uniquer per user" do
	debt1 = FactoryGirl.create(:debt1)
	debt2 = FactoryGirl.build(:debt1, name: debt1.name)
	expect(debt2).to_not be_valid
  end

  it "has a fix amount present and payment start date" 

  it "has a fix amount present and schedule present"

  it "has many account balances"

  it "has many debt balances" do
	debt2 = FactoryGirl.create(:debt_with_debt_balances)
	expect(debt2.debt_balances.length).to eq(1)
  end
 
end
