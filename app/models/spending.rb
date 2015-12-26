class Spending < ActiveRecord::Base
  belongs_to :budget, -> { includes :category }
  belongs_to :payment_method
  belongs_to :debt_balance

  attr_accessor :category_id
  attr_accessor :debt_id

  validates_presence_of :description, :spending_date, :amount, :payment_method_id, :category_id 
  validates :amount, numericality: true, exclusion: { in: [0], message: "can't be %{value}."}
  validate :spending_goal, :unless => Proc.new{|k| k.category_id.blank? }

  #def has_debt
    
  #end  
   
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

  def authorize(user=nil)
    ( self.payment_method.user.id == user.id || self.payment_method.user.contributors.where(id: user.id).exists? )
  end

  private
  def set_goal
    db = DebtBalance.where("debt_balances.payment_start_date <= '#{self.spending_date}' AND '#{self.spending_date}' <= due_date AND debt_id = #{self.debt_id.to_i}")
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
      self.description = self.description.titleize unless self.description.nil?
      self.debt_id = nil if self.debt_id.blank?
  end

  def spending_goal
    if Category.find(self.category_id.to_i).debts.any?
      if self.debt_id.blank?
        errors.add(:category, "you must pick a goal for this category")
      elsif Debt.find(self.debt_id).category.id != self.category_id.to_i
        errors.add(:category, "doesn't match with goal.")
      elsif Debt.find(self.debt_id).debt_balances.empty?
        errors.add(:category, "don't have a set goal.")
      else
        self.description = Debt.find(self.debt_id).name
        set_goal
      end 
    end
  end

end
