FactoryGirl.define do
  factory :income_source do
    pay_day "friday"
    name { Faker::Company.name[0..19] }
    amount { Faker::Commerce.price }
    pay_schedule "bi-weekly"
    start_date "2015-12-04"
    end_date "2015-12-31"
    account
  end

end
