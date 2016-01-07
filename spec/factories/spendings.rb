require 'faker'

FactoryGirl.define do
  factory :spending do
    amount { Faker::Commerce.price }
    description { Faker::Commerce.product_name }
    spending_date { Faker::Date.between(2.days.ago, Date.today) }
    budget
    payment_method
  end
end
