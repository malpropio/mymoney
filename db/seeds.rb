# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Spending.delete_all
Budget.delete_all
Category.delete_all

ActiveRecord::Base.connection.execute("ALTER TABLE categories AUTO_INCREMENT = 1")
ActiveRecord::Base.connection.execute("ALTER TABLE spendings AUTO_INCREMENT = 1")
ActiveRecord::Base.connection.execute("ALTER TABLE budgets AUTO_INCREMENT = 1")

#Seed categories
10.times do |n|
  description  = Faker::Commerce.product_name
  name  = Faker::Commerce.department(5,false)
  Category.create(name: name, description:  description)
end

#Sample spendings
100.times do |n|
  description  = Faker::Commerce.product_name
  category_id  = Faker::Number.number(1).to_i+1
  spending_date = Faker::Time.between("2014-08-01", "2015-08-31")
  amount = Faker::Commerce.price
  Spending.create(description:  description,
  	       category_id:  category_id,
               spending_date: spending_date,
               amount: amount)
end
