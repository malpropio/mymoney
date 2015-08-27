class Spending < ActiveRecord::Base
  belongs_to :category
  belongs_to :budget

  validates_presence_of :description, :category_id, :spending_date, :amount
  validates :amount, numericality: true

  before_save do
    set_budget
  end

  after_create do
    set_budget
  end

  private
  def set_budget
    dt = self.spending_date.change(day: 1).strftime('%Y-%m')            
    new_budget = Budget.where("DATE_FORMAT(budget_month, '%Y-%m') = ? AND category_id = ?", dt, self.category_id)
    self.budget_id = new_budget.first.id unless new_budget.first.nil?
  end
  
end
