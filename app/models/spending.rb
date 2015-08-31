class Spending < ActiveRecord::Base
  belongs_to :category
  belongs_to :budget

  attr_accessor :description_select

  validates_presence_of :description, :category_id, :spending_date, :amount
  validates :amount, numericality: true

  before_save do
    set_budget
  end

  after_create do
    set_budget
  end

  ## Set description to loans if loans selected
  before_validation :clean_desc

  def self.search(search)
    if search
      where('description LIKE ?', "%#{search}%")
    else
      all
    end
  end

  private
  def set_budget
    dt = self.spending_date.change(day: 1).strftime('%Y-%m')            
    new_budget = Budget.where("DATE_FORMAT(budget_month, '%Y-%m') = ? AND category_id = ?", dt, self.category_id)
    self.budget_id = new_budget.first.id unless new_budget.first.nil?
  end

  def clean_desc
    self.description = self.description_select if (!self.category.nil? && self.category.name == 'Loans')
  end

end
