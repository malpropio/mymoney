require 'faker'

# This will guess the User class
FactoryGirl.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email(first_name) }
    username { Faker::Internet.user_name(first_name) }
    password "abcabc"
    password_confirmation "abcabc"

    factory :user_with_accounts do
      transient do
        accounts_count 2
      end

      after(:create) do |user, evaluator|
        create_list(:account, evaluator.accounts_count, user: user)
      end
    end

    factory :user_with_categories do
      transient do
        categories_count 2
      end

      after(:create) do |user, evaluator|
        create_list(:category, evaluator.categories_count, user: user)
      end
    end

    factory :user_with_payment_methods do
      transient do
        payment_methods_count 2
      end

      after(:create) do |user, evaluator|
        create_list(:payment_method, evaluator.payment_methods_count, user: user)
      end
    end
  end
end
