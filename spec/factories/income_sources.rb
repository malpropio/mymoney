FactoryGirl.define do
  factory :income_source do
    pay_day "friday"
    name { Faker::Company.name[0..19] }
    amount 1000.0
    pay_schedule "bi-weekly"
    start_date "2015-12-04"
    end_date "2016-01-01"
    account
  end

end
