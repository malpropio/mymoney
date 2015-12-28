require 'rails_helper'

RSpec.describe User, type: :model do
  it "has a valid factory" do
    expect(FactoryGirl.build(:user)).to be_valid
  end

  context "is invalid when" do
    it "firstname is empty" do
      user = FactoryGirl.build(:user, first_name: nil)
      expect(user).to_not be_valid
      expect(user.errors).to have_key(:first_name)
    end

    it "lastname is empty" do
      user = FactoryGirl.build(:user, last_name: nil)
      expect(user).to_not be_valid
      expect(user.errors).to have_key(:last_name)
    end

    it "username is empty" do
      user = FactoryGirl.build(:user, username: nil)
      expect(user).to_not be_valid
      expect(user.errors).to have_key(:username)
    end

    it "email is empty" do
      user = FactoryGirl.build(:user, email: nil)
      expect(user).to_not be_valid
      expect(user.errors).to have_key(:email)
    end

    it "email is not well formatted" do
      user = FactoryGirl.build(:user, email: "test.com")
      expect(user).to_not be_valid
      expect(user.errors).to have_key(:email)
      user = FactoryGirl.build(:user, email: "test@test")
      expect(user).to_not be_valid
      expect(user.errors).to have_key(:email)
    end

    it "email is not unique" do
      user_1 = FactoryGirl.create(:user, email: "test@test.com")
      user_2 = FactoryGirl.build(:user, email: "test@test.com")
      expect(user_2).to_not be_valid
      expect(user_2.errors).to have_key(:email)
    end

    it "password is empty" do
      user = FactoryGirl.build(:user, password: nil)
      expect(user).to_not be_valid
      expect(user.errors).to have_key(:password)
    end

    it "password is too short" do
      user = FactoryGirl.build(:user, password: "abc", password_confirmation: "abc")
      expect(user).to_not be_valid
      expect(user.errors).to have_key(:password)
    end

    it "password and password confirmation don't match" do
      user = FactoryGirl.build(:user, password: "password")
      expect(user).to_not be_valid
      expect(user.errors).to have_key(:password_confirmation)
    end 
  end

  context "association" do
    it "has many categories" do
      user = FactoryGirl.create(:user_with_categories)
      expect(user.categories.length).to eq(2)
    end

    it "has many payment_methods" do
      user = FactoryGirl.create(:user_with_payment_methods)
      expect(user.payment_methods.length).to eq(2)
    end

    it "has many accounts" do
      user = FactoryGirl.create(:user_with_accounts)
      expect(user.accounts.length).to eq(2)
    end
    
    it "has many contributors" do
      user = FactoryGirl.create(:user_with_contributors)
      expect(user.contributors.length).to eq(1)
    end

    it "has many contributors and contributes to many" do
      user = FactoryGirl.create(:user_has_and_belongs_to_many_contributors)
      expect(user.contributors.length).to eq(1)
      contributor = user.contributors.first
      expect(contributor.contributors.where(id: user.id)).to exist
    end

    it "has many budgets" do
      user = FactoryGirl.create(:user_with_budgets)
      expect(user.budgets.length).to eq(1)
    end
    
    it "has many spendings" do
      user = FactoryGirl.create(:user_with_spendings)
      expect(user.spendings.length).to eq(1)
    end
    
    it "has many income_sources" do
      user = FactoryGirl.create(:user_with_income_sources)
      expect(user.income_sources.length).to eq(1)
    end
  
    it "has many debts" do
      user = FactoryGirl.create(:user_with_debts)
      expect(user.debts.length).to eq(1)
    end
    
    it "has many account_balances" do
      user = FactoryGirl.create(:user_with_account_balances)
      expect(user.account_balances.length).to eq(1)
    end
    
    it "has many debt_balances" do
      user = FactoryGirl.create(:user_with_debt_balances)
      expect(user.debt_balances.length).to eq(1)
    end
    
    it "has many account_balance_distributions" do
      skip "MIGHT BE DELETED"
    end 
  end

  context "has contributor but doesn't contributes" do
    it "cant see eachothers spendings" do
      user_1 = FactoryGirl.create(:user_with_spendings)
      user_2 = FactoryGirl.create(:user_with_spendings)
      user_1.contributors << user_2
      expect(user_1.get_all("spendings").length).to eq(1)
    end
    

    it 'cant see eachothers categories' do 
      user_1 = FactoryGirl.create(:user_with_categories) 
      user_2 = FactoryGirl.create(:user_with_categories) 
      user_1.contributors << user_2 
      expect(user_1.get_all('categories').length).to eq(2)
    end

    it 'cant see eachothers payment_methods' do 
      user_1 = FactoryGirl.create(:user_with_payment_methods) 
      user_2 = FactoryGirl.create(:user_with_payment_methods) 
      user_1.contributors << user_2 
      expect(user_1.get_all('payment_methods').length).to eq(2)
    end

    it 'cant see eachothers accounts' do 
      user_1 = FactoryGirl.create(:user_with_accounts) 
      user_2 = FactoryGirl.create(:user_with_accounts) 
      user_1.contributors << user_2 
      expect(user_1.get_all('accounts').length).to eq(2)
    end

    it 'cant see eachothers account_balances' do 
      user_1 = FactoryGirl.create(:user_with_account_balances) 
      user_2 = FactoryGirl.create(:user_with_account_balances) 
      user_1.contributors << user_2 
      expect(user_1.get_all('account_balances').length).to eq(1)
    end

    it 'cant see eachothers account_balance_distributions' do
      skip "MIGHT BE DELETED" 
      #user_1 = FactoryGirl.create(:user_with_account_balance_distributions) 
      #user_2 = FactoryGirl.create(:user_with_account_balance_distributions) 
      #user_1.contributors << user_2 
      #expect(user_1.get_all('account_balance_distributions').length).to eq(1)
    end

    it 'cant see eachothers budgets' do 
      user_1 = FactoryGirl.create(:user_with_budgets) 
      user_2 = FactoryGirl.create(:user_with_budgets) 
      user_1.contributors << user_2 
      expect(user_1.get_all('budgets').length).to eq(1)
    end

    it 'cant see eachothers debts' do 
      user_1 = FactoryGirl.create(:user_with_debts) 
      user_2 = FactoryGirl.create(:user_with_debts) 
      user_1.contributors << user_2 
      expect(user_1.get_all('debts').length).to eq(1)
    end

    it 'cant see eachothers debt_balances' do 
      user_1 = FactoryGirl.create(:user_with_debt_balances) 
      user_2 = FactoryGirl.create(:user_with_debt_balances) 
      user_1.contributors << user_2 
      expect(user_1.get_all('debt_balances').length).to eq(1)
    end

    it 'cant see eachothers income_sources' do 
      user_1 = FactoryGirl.create(:user_with_income_sources) 
      user_2 = FactoryGirl.create(:user_with_income_sources) 
      user_1.contributors << user_2 
      expect(user_1.get_all('income_sources').length).to eq(1)
    end

    it 'cant see eachothers spendings' do 
      user_1 = FactoryGirl.create(:user_with_spendings) 
      user_2 = FactoryGirl.create(:user_with_spendings) 
      user_1.contributors << user_2 
      expect(user_1.get_all('spendings').length).to eq(1)
    end
  end

  context "when has contributor and contributes" do
    it "can see eachothers spendings" do
      user_1 = FactoryGirl.create(:user_with_spendings)
      user_2 = FactoryGirl.create(:user_with_spendings)
      user_1.contributors << user_2
      user_2.contributors << user_1
      expect(user_1.get_all("spendings").length).to eq(2)
    end
    

    it 'can see eachothers categories' do 
      user_1 = FactoryGirl.create(:user_with_categories) 
      user_2 = FactoryGirl.create(:user_with_categories) 
      user_1.contributors << user_2 
      user_2.contributors << user_1
      expect(user_1.get_all('categories').length).to eq(4)
    end

    it 'can see eachothers payment_methods' do 
      user_1 = FactoryGirl.create(:user_with_payment_methods) 
      user_2 = FactoryGirl.create(:user_with_payment_methods) 
      user_1.contributors << user_2 
      user_2.contributors << user_1
      expect(user_1.get_all('payment_methods').length).to eq(4)
    end

    it 'can see eachothers accounts' do 
      user_1 = FactoryGirl.create(:user_with_accounts) 
      user_2 = FactoryGirl.create(:user_with_accounts) 
      user_1.contributors << user_2 
      user_2.contributors << user_1
      expect(user_1.get_all('accounts').length).to eq(4)
    end

    it 'can see eachothers account_balances' do 
      user_1 = FactoryGirl.create(:user_with_account_balances) 
      user_2 = FactoryGirl.create(:user_with_account_balances) 
      user_1.contributors << user_2 
      user_2.contributors << user_1
      expect(user_1.get_all('account_balances').length).to eq(2)
    end

    it 'can see eachothers account_balance_distributions' do 
      skip "MIGHT BE DELETED"
    end

    it 'can see eachothers budgets' do 
      user_1 = FactoryGirl.create(:user_with_budgets) 
      user_2 = FactoryGirl.create(:user_with_budgets) 
      user_1.contributors << user_2 
      user_2.contributors << user_1
      expect(user_1.get_all('budgets').length).to eq(2)
    end

    it 'can see eachothers debts' do 
      user_1 = FactoryGirl.create(:user_with_debts) 
      user_2 = FactoryGirl.create(:user_with_debts) 
      user_1.contributors << user_2 
      user_2.contributors << user_1
      expect(user_1.get_all('debts').length).to eq(2)
    end

    it 'can see eachothers debt_balances' do 
      user_1 = FactoryGirl.create(:user_with_debt_balances) 
      user_2 = FactoryGirl.create(:user_with_debt_balances) 
      user_1.contributors << user_2 
      user_2.contributors << user_1
      expect(user_1.get_all('debt_balances').length).to eq(2)
    end

    it 'can see eachothers income_sources' do 
      user_1 = FactoryGirl.create(:user_with_income_sources) 
      user_2 = FactoryGirl.create(:user_with_income_sources) 
      user_1.contributors << user_2 
      user_2.contributors << user_1
      expect(user_1.get_all('income_sources').length).to eq(2)
    end

    it 'can see eachothers spendings' do 
      user_1 = FactoryGirl.create(:user_with_spendings) 
      user_2 = FactoryGirl.create(:user_with_spendings) 
      user_1.contributors << user_2 
      user_2.contributors << user_1
      expect(user_1.get_all('spendings').length).to eq(2)
    end
  end

  context "columns format" do
    it "converts valid email to lowercase" do
      user = FactoryGirl.build(:user)
      expect(user.email).to eq(user.email.downcase)
    end
  end
end
