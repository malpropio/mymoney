class DebtBalance < ActiveRecord::Base
  belongs_to :debt

  validates_presence_of :debt_id, :due_date, :balance
  validates :balance, numericality: true

  validates_uniqueness_of :debt_id, :scope => :due_date, message: "already set for this month"

  before_validation do 
    self.due_date = self.due_date.change(day: self.debt.due_day) unless self.due_date.blank? 
  end

  def payments
    Spending.joins(:category)
            .where("spendings.description = '#{self.debt.name}' AND categories.name = '#{self.debt.category}'")
            .where("spending_date>'#{self.due_date - 1.month}' AND spending_date<='#{self.due_date}'")
            #.sum(:amount)
  end
end
