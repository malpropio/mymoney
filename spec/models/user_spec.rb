require 'rails_helper'

RSpec.describe User, type: :model do
  it "has a valid factory" do
    expect(FactoryGirl.build(:user)).to be_valid
  end

  it "is invalid without a firstname" do
    user = FactoryGirl.build(:user, first_name: nil)
    expect(user).to_not be_valid
    expect(user.errors).to have_key(:first_name)
  end

  it "is invalid without a lastname" do
    user = FactoryGirl.build(:user, last_name: nil)
    expect(user).to_not be_valid
    expect(user.errors).to have_key(:last_name)
  end

  it "is invalid without a username" do
    user = FactoryGirl.build(:user, username: nil)
    expect(user).to_not be_valid
    expect(user.errors).to have_key(:username)
  end

  it "is invalid without an email" do
    user = FactoryGirl.build(:user, email: nil)
    expect(user).to_not be_valid
    expect(user.errors).to have_key(:email)
  end

  it "is invalid if the email is not well formatted" do
    user = FactoryGirl.build(:user, email: "test.com")
    expect(user).to_not be_valid
    expect(user.errors).to have_key(:email)
    user = FactoryGirl.build(:user, email: "test@test")
    expect(user).to_not be_valid
    expect(user.errors).to have_key(:email)
  end

  it "is invalid if email is not unique" do
    user_1 = FactoryGirl.create(:user, email: "test@test.com")
    user_2 = FactoryGirl.build(:user, email: "test@test.com")
    expect(user_2).to_not be_valid
    expect(user_2.errors).to have_key(:email)
  end

  it "converts valid email to lowercase" do
    user = FactoryGirl.build(:user)
    expect(user.email).to eq(user.email.downcase)
  end

  it "is invalid without a password" do
    user = FactoryGirl.build(:user, password: nil)
    expect(user).to_not be_valid
    expect(user.errors).to have_key(:password)
  end

  it "is invalid if password is too short" do
    user = FactoryGirl.build(:user, password: "abc", password_confirmation: "abc")
    expect(user).to_not be_valid
    expect(user.errors).to have_key(:password)
  end

  it "is invalid if password and password confirmation don't match" do
    user = FactoryGirl.build(:user, password: "password")
    expect(user).to_not be_valid
    expect(user.errors).to have_key(:password_confirmation)
  end

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

  #it "returns a contact's full name as a string" do
  #  FactoryGirl(:contact, firstname: "John", lastname: "Doe").name.should == "John Doe"
  #end

  #describe "filter last name by letter" do      
  #  before :each do
  #    @smith = FactoryGirl(:contact, lastname: "Smith")
  #    @jones = FactoryGirl(:contact, lastname: "Jones")
  #    @johnson = FactoryGirl(:contact, lastname: "Johnson")
  #  end

  #  context "matching letters" do
  #    it "returns a sorted array of results that match" do
  #      Contact.by_letter("J").should == [@johnson, @jones]
  #    end
  #  end

  #  context "non-matching letters" do
  #    it "does not return contacts that don't start with the provided letter" do
  #      Contact.by_letter("J").should_not include @smith
  #    end
  #  end
  #end
end
