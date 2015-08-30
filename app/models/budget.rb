class Budget < ActiveRecord::Base
  belongs_to :category
  has_many :spendings

  validates_presence_of :category_id, :budget_month, :amount
  validates :amount, numericality: true

  validates_uniqueness_of :category_id, :scope => :budget_month, message: "already set for this month"

  before_validation do 
                      self.budget_month = self.budget_month.change(day: 1) unless self.budget_month.blank? 
  end 
end
