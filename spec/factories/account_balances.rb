FactoryGirl.define do
  factory :account_balance do
    paid false
    amount '9.99'
    buffer '9.99'
    balance_date '2015-12-27'
    account
    debt
  end
end
