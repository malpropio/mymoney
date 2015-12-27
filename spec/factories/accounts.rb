FactoryGirl.define do
  factory :account do
    account_type { Faker::Business.credit_card_type }
    name { Faker::Company.name[0...19] }
    user  
  end

end
