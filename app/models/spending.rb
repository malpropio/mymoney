class Spending < ActiveRecord::Base
  belongs_to :category
  belongs_to :budget
  belongs_to :payment_method
  belongs_to :debt_balance

  attr_accessor :debt_id

  validates_presence_of :description, :category_id, :spending_date, :amount, :payment_method_id
  validates :amount, numericality: true, exclusion: { in: [0], message: "can't be %{value}."}
  validate :spending_goal, :if => Proc.new{|k| k.category.debts.active.exists?}
 
  DEBIT_CATEGORIES = ['Credit Cards','Loans','Rent','Utilities','Savings']

  before_save do
    set_budget
    set_goal
  end

  after_create do
    set_budget
    set_goal
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
  def set_goal
    db = DebtBalance.joins(debt: :category).where("debt_balances.payment_start_date <= '#{self.spending_date}' AND '#{self.spending_date}' <= due_date AND (debts.name = '#{self.description}' OR categories.id = #{self.category.id})")
    if db.exists?
      self.debt_balance_id = db.first.id
    end
  end

  def set_budget
    dt = self.spending_date.change(day: 1).strftime('%Y-%m')            
    new_budget = Budget.where("DATE_FORMAT(budget_month, '%Y-%m') = ? AND category_id = ?", dt, self.category_id)
    if new_budget.exists?
      self.budget_id = new_budget.first.id
    else
      new_budget = Budget.new({"category_id"=>self.category_id, "budget_month"=>self.spending_date, "amount"=>"0"})
      new_budget.save
      self.budget_id = new_budget.id
    end
  end

  def clean_desc
    if !self.category.nil?
      self.payment_method_id = PaymentMethod.find_by_name("Debit").id if (DEBIT_CATEGORIES.include? self.category.name)
      self.description = self.description.titleize unless self.description.nil?
    end
  end

  def spending_goal
    if self.debt_id.blank? || Debt.find(self.debt_id).category != self.category
      errors.add(:category, "doesn't match with goal.")
    else
      self.description = Debt.find(self.debt_id).name
    end 
  end

end
