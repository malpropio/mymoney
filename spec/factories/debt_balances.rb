FactoryGirl.define do
  factory :debt_balance do
    balance { Faker::Commerce.price }
    payment_start_date { Faker::Date.between(5.days.ago, 3.days.ago) }
    due_date { Faker::Date.between(2.days.ago, Date.today) }
    target_balance { Faker::Commerce.price }
    debt
  end

end
