class DebtBalance < ActiveRecord::Base
  include DateModule

  belongs_to :debt

  has_many :spendings

  validates_presence_of :debt_id, :due_date, :balance
  validates :balance, numericality: true

  validates_uniqueness_of :debt_id, :scope => :due_date, message: "balance already due on this date"
  #validate :budget_not_set_for_month
  validate :start_pay_date

  before_validation do 
    self.payment_start_date = self.due_date - 1.months + 1.days if !self.due_date.blank? && self.payment_start_date.blank?
  end

  def to_s
    debt.name
  end

  def authorize(user=nil)
    owner = self.debt.account.user
    owner.id == user.id || owner.contributors.where(id: user.id).exists? 
  end

  def payments(up_to_date = nil, inclusive = false)
    comparison = inclusive ? "<=" : "<"
    threshold = "AND spending_date#{comparison}'#{up_to_date}'" unless up_to_date.nil?
    self.spendings.where("spending_date>='#{self.payment_start_date}' AND spending_date<='#{self.due_date}' #{threshold}")
  end

  def balance_of_interest
    current_balance = ( self.target_balance - self.balance ).abs
  end

  def payment_due(payment_date = nil, live = true)
    result = 0
    max = live ? max_payment(payment_date) : 999999 #TODO: fix
    if self.debt.fix_amount
      if self.debt.schedule == "Bi-Weekly"
        result = bi_weekly_due(self.debt.payment_start_date,payment_date) ? self.debt.fix_amount  : 0
      elsif self.debt.schedule == "Monthly"
        debt_account = self.debt.account
        paychecks_todate = self.debt.account.user.get_income_sources.total_paychecks(debt_account,payment_date.at_beginning_of_month,payment_date) 
        paychecks_all = self.debt.account.user.get_income_sources.total_paychecks(debt_account, payment_date.at_beginning_of_month,payment_date.at_end_of_month)
        result = (self.debt.fix_amount*paychecks_todate)/paychecks_all unless paychecks_all==0
      end
    else
      paychecks_all = self.debt.account.user.get_income_sources.total_paychecks(self.debt.account,self.payment_start_date, self.due_date)
      result = self.balance_of_interest/paychecks_all unless paychecks_all==0
    end
    result
  end

  def after_pay_balance(up_to_date = nil, inclusive = false)
    if self.debt.is_asset?
      self.balance + payments(up_to_date, inclusive).sum(:amount)
    else
      self.balance - payments(up_to_date, inclusive).sum(:amount)
    end
  end
  
  def max_payment(up_to_date = nil, inclusive = false)
    if self.debt.is_asset?
      (self.target_balance - self.after_pay_balance(up_to_date, inclusive)).round(2)
    else
      (self.after_pay_balance(up_to_date, inclusive) - self.target_balance).round(2)
    end
  end

  def close
    if self.debt.is_asset?
      new_target_balance = self.balance + ( payment_due * payments_to_date )
    else
      new_target_balance = self.balance - ( payment_due * payments_to_date )
    end
    
    update_attribute(:target_balance, new_target_balance)    
    update_attribute(:due_date, Time.now.to_date)
  end
  
  def in_payment?(date = Time.now.to_date)
    payment_start_date <= date && date <= due_date
  end

  def self.search(search)
    if search
      search[:debt_id].blank? ? all : where(debt_id: search[:debt_id])
    else
      all
    end
  end

  private
  def budget_not_set_for_month
    errors.add(:debt, "balance already set for #{self.due_date.strftime('%B %Y')}") if DebtBalance.where("id != #{self.id || 0} AND debt_id = #{self.debt_id} AND DATE_FORMAT(due_date, '%Y-%m-%01') = DATE_FORMAT('#{self.due_date}', '%Y-%m-%01')").exists? 
  end

  def start_pay_date
    if DebtBalance.where("id != #{self.id || 0} AND debt_id = #{self.debt_id} AND '#{self.payment_start_date}' <= due_date AND '#{self.due_date}' > due_date").exists?
      previous = DebtBalance.where("id != #{self.id || 0} AND debt_id = #{self.debt_id} AND '#{self.payment_start_date}' <= due_date AND '#{self.due_date}' > due_date").order(due_date:  "desc").first
      errors.add(:payment_start_date, "must be after #{previous.due_date}.")
    end

    if DebtBalance.where("id != #{self.id || 0} AND debt_id = #{self.debt_id} AND '#{self.payment_start_date}' >= payment_start_date AND '#{self.payment_start_date}' <= due_date").exists?
      goal = DebtBalance.where("id != #{self.id || 0} AND debt_id = #{self.debt_id} AND '#{self.payment_start_date}' >= payment_start_date AND '#{self.payment_start_date}' <= due_date").order(due_date:  "desc").first
      errors.add(:goal, "already set between #{goal.payment_start_date} and #{goal.due_date}")
    end

    if DebtBalance.where("id != #{self.id || 0} AND debt_id = #{self.debt_id} AND '#{self.due_date}' >= payment_start_date AND '#{self.due_date}' <= due_date").exists?
      goal = DebtBalance.where("id != #{self.id || 0} AND debt_id = #{self.debt_id} AND '#{self.due_date}' >= payment_start_date AND '#{self.due_date}' <= due_date").order(due_date:  "desc").first
      errors.add(:goal, "already set between #{goal.payment_start_date} and #{goal.due_date}")
    end
    
    if !self.due_date.blank? && !self.payment_start_date.blank?
      if self.due_date < self.payment_start_date
        errors.add(:payment_start_date, "(#{self.payment_start_date}) must be before due date (#{self.due_date})")
      end
    end
  end

end
