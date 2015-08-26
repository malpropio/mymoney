class Category < ActiveRecord::Base
  has_many :spendings  
  has_many :budgets

  validates_presence_of :description, :name
end
