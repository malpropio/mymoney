require 'faker'

FactoryGirl.define do
  factory :spending do
    amount { Faker::Commerce.price }
    budget
    category
    debt_balance
    description { Faker::Commerce.product_name }
    payment_method
    spending_date { Faker::Date.between(2.days.ago, Date.today) }
  end

end
