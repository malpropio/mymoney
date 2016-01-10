require 'faker'

FactoryGirl.define do
  factory :payment_method do
    name { Faker::Commerce.product_name }
    description { Faker::Commerce.department(5) }
    user
  end
end
