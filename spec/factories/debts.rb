FactoryGirl.define do
  factory :debt do
    sub_category "MyString"
    name { Faker::Company.name }
    is_asset false
    deleted_at nil
    fix_amount "9.99"
    schedule "MyString"
    payment_start_date "2015-12-27"
    autopay false
    category
    account
  end

end
