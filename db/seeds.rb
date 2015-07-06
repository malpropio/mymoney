# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

#Seed categories
Category.create(name: "Restaurants/Dining", description: "Anytime dining out spending")
Category.create(name: "Uncategorized", description: "Spending not yet categorized")
Category.create(name: "Travel", description: "Any travel related spending: airfair, bus ticket, taxi")
Category.create(name: "Entertainment", description: "The fun stuff")
Category.create(name: "Groceries", description: "Grocery store shopping")
Category.create(name: "Gas/Transportation", description: "Gas, metro, etc...")
Category.create(name: "Phone/TV/Internet", description: "AT&T, Verizon, etc...")
Category.create(name: "Insurance", description: "Auto Insurance, Renter Insurance, etc...")
Category.create(name: "Gym", description: "Gym memberships and gym related expenses")
Category.create(name: "Utilities", description: "Utility spendings: gas, electric, water, sewer, etc...")
Category.create(name: "Rent", description: "Any rent related expense")
Category.create(name: "Loans", description: "Loan payments: car, student")

#Sample spendings
100.times do |n|
  description  = Faker::Commerce.product_name
  category_id  = Faker::Number.number(1).to_i+1
  spending_date_ts = Faker::Time.between(DateTime.now - 60, DateTime.now)
  amount = Faker::Commerce.price
  Spending.create(description:  description,
  	       category_id:  category_id,
               spending_date_ts: spending_date_ts,
               amount: amount)
end
