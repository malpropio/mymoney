require 'faker'

FactoryGirl.define do
  factory :category do
    name { Faker::Commerce.product_name }
    description { Faker::Commerce.department(5) }
    user
  end

  factory :category_with_budgets do
    transient do
      budgets_count 2
    end

    after(:create) do |category, evaluator|
      create_list(:budget, evaluator.budgets_count, category: category)
    end
  end
end
