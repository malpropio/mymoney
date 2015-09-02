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
PaymentMethod.delete_all

ActiveRecord::Base.connection.execute("ALTER TABLE categories AUTO_INCREMENT = 1")
ActiveRecord::Base.connection.execute("ALTER TABLE spendings AUTO_INCREMENT = 1")
ActiveRecord::Base.connection.execute("ALTER TABLE budgets AUTO_INCREMENT = 1")
ActiveRecord::Base.connection.execute("ALTER TABLE payment_methods AUTO_INCREMENT = 1")

#Seed categories
3.times do |n|
  description  = Faker::Commerce.product_name
  name  = Faker::Commerce.department(5,false)
  Category.create(name: name, description:  description)
end

# Add loan category
Category.create(name: "Loans", description: "All loans")

#Sample spendings
100.times do |n|
  description  = Faker::Commerce.product_name
  description_select = Faker::Commerce.product_name
  category_id  = Faker::Number.between(1,4)
  spending_date = Faker::Time.between("2015-05-01", DateTime.now.change(day: 28))
  amount = Faker::Commerce.price
  Spending.create(description:  description,
  	       category_id:  category_id,
               spending_date: spending_date,
               amount: amount,
               description_select: description_select)
end

PaymentMethod.create(name: "Credit Card", description: "Any of our cc")
PaymentMethod.create(name: "Debit Card", description: "Any of our debit")
PaymentMethod.create(name: "Gift Card", description: "Any gift card")
PaymentMethod.create(name: "Cash", description: "Cash")
PaymentMethod.create(name: "Other", description: "Any other form of payments")
