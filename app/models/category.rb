class Category < ActiveRecord::Base
  #has_many :spendings  
  has_many :budgets
  has_many :debts
  
  belongs_to :user

  validates_presence_of :description, :name
  validates_uniqueness_of :name, case_sensitive: false
end
