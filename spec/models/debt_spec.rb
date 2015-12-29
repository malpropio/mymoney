require 'rails_helper'

RSpec.describe Debt, type: :model do
  it "has a valid factory" do
	expect(FactoryGirl.build(:debt)).to be_valid
  end

  it "is invalid without name" do
	debt = FactoryGirl.build(:debt, name: nil)
	expect(debt).to_not be_valid
	expect(debt.errors).to have_key(:name)
  end

  it "is invalid without category" do
	debt = FactoryGirl.build(:debt, category: nil)
	expect(debt).to_not be_valid
	expect(debt.errors).to have_key(:category_id)
  end

  it "has many debt balances" 
	 
end
