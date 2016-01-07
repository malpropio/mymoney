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

    factory :user_with_contributors do
      transient do
        other { FactoryGirl.create(:user) }
      end

      after(:create) do |user, evaluator|
        user.contributors << evaluator.other
      end
    end

    factory :user_has_and_belongs_to_many_contributors do
      transient do
        other { FactoryGirl.create(:user) }
      end

      after(:create) do |user, evaluator|
        user.contributors << evaluator.other
        evaluator.other.contributors << user
      end
    end

    factory :user_with_budgets do
      transient do
        budget { FactoryGirl.create(:budget) }
        category { FactoryGirl.create(:category) }
      end

      after(:create) do |user, evaluator|
          evaluator.category.budgets << evaluator.budget
          user.categories << evaluator.category
      end
    end

    factory :user_with_spendings do
      transient do
        spending { FactoryGirl.create(:spending) }
        payment_method { FactoryGirl.create(:payment_method) }
      end

      after(:create) do |user, evaluator|
          evaluator.payment_method.spendings << evaluator.spending
          user.payment_methods << evaluator.payment_method
      end
    end

    factory :user_with_income_sources do
      transient do
        account { FactoryGirl.create(:account) }
        income_source { FactoryGirl.create(:income_source) }
      end

      after(:create) do |user, evaluator|
        evaluator.account.income_sources << evaluator.income_source
        user.accounts << evaluator.account
      end
    end

    factory :user_with_debts do
      transient do
        debt { FactoryGirl.create(:debt) }
        account { FactoryGirl.create(:account) }
      end

      after(:create) do |user, evaluator|
          evaluator.account.debts << evaluator.debt
          user.accounts << evaluator.account
      end
    end

    factory :user_with_account_balances do
      transient do
        account_balance { FactoryGirl.create(:account_balance) }
        account { FactoryGirl.create(:account) }
      end

      after(:create) do |user, evaluator|
          evaluator.account.account_balances << evaluator.account_balance
          user.accounts << evaluator.account
      end
    end

    factory :user_with_debt_balances do
      transient do
        debt_balance { FactoryGirl.create(:debt_balance) }
        debt { FactoryGirl.create(:debt) }
        account { FactoryGirl.create(:account) }
      end

      after(:create) do |user, evaluator|
          evaluator.debt.debt_balances << evaluator.debt_balance
          evaluator.account.debts << evaluator.debt
          user.accounts << evaluator.account
      end
    end
  end
end
