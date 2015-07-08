class Spending < ActiveRecord::Base
  belongs_to :category

  validates_presence_of :description, :category_id, :spending_date, :amount
  validates :amount, numericality: true
  
end
