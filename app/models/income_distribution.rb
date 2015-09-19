class IncomeDistribution < ActiveRecord::Base
  include DateModule

  validates_presence_of :distribution_date, :boa_chk, :chase_chk
  validates_numericality_of :boa_chk, :chase_chk
  validates_uniqueness_of :distribution_date

  validate :validate_date_is_friday

  RENT = 1550
  CAR_LOAN = 186.19
  BOA_BUFFER = 10
  CHASE_BUFFER = 10

  def boa_total_fixed
    BOA_BUFFER + rent_alloc + car_alloc + travel_alloc + cash_alloc + jcp_alloc + express_alloc + savings_alloc
  end

  def boa_total_distribution
    boa_total_fixed + amex_alloc + extra_savings_alloc
  end

  def chase_total_fixed
    CHASE_BUFFER + student_alloc
  end

  def chase_total_distribution
    chase_total_fixed + freedom_alloc + chase_extra
  end

  def chase_extra
    [0, self.chase_chk - chase_total_fixed - freedom_alloc].max
  end

  def amex_alloc
    [self.amex, [self.boa_chk - boa_total_fixed, 0 ].max].min
  end

  def extra_savings_alloc
    [0, self.boa_chk - boa_total_fixed - amex_alloc].max
  end

  def freedom_alloc
    [self.freedom, [self.chase_chk - chase_total_fixed, 0 ].max].min
  end

  def travel_alloc
    self.travel
  end

  def cash_alloc
    self.cash
  end

  def jcp_alloc
    self.jcp
  end

  def express_alloc
    self.express
  end

  def car_alloc
    self.distribution_date.cweek % 2 == 1 ? CAR_LOAN : 0
  end

  def student_alloc
    result = 0
    student_loans.each {|loan| result += loan.chase_payment_due }
    self.distribution_date.cweek % 2 == 0 ? result : 0 
  end

  def student_loans
    self.distribution_date.cweek % 2 == 0 ? DebtBalance.joins(:debt).where("payment_start_date<='#{self.distribution_date}' AND due_date>='#{self.distribution_date}' AND debts.sub_category = 'Student Loans'") : []
  end

  def savings_alloc
    result = 0
    savings.each {|saving| result += saving.boa_payment_due }
    result
  end

  def savings
    DebtBalance.joins(:debt).where("payment_start_date<='#{self.distribution_date}' AND due_date>='#{self.distribution_date}' AND debts.sub_category = 'Savings'")
  end
  
  def rent_alloc
    (RENT*boa_fridays(self.distribution_date.at_beginning_of_month,self.distribution_date))/boa_fridays(self.distribution_date.at_beginning_of_month,self.distribution_date.at_end_of_month)
  end

  def boa_balance_left
    self.boa_chk - boa_total_distribution + BOA_BUFFER
  end

  def chase_balance_left
    self.chase_chk - chase_total_distribution + CHASE_BUFFER
  end

  def amex
    #result = DebtBalance.joins(:debt).where("payment_start_date<='#{self.distribution_date}' AND due_date>='#{self.distribution_date}' AND debts.name = 'Amex'")
    #result.exists? ? result.first.boa_payment_due : 0
    amout_due('Amex','Bank Of America')
  end

  def freedom
    result = DebtBalance.joins(:debt).where("payment_start_date<='#{self.distribution_date}' AND due_date>='#{self.distribution_date}' AND debts.name = 'Freedom'")
    result.exists? ? result.first.chase_payment_due : 0
  end

  def travel
    result = DebtBalance.joins(:debt).where("payment_start_date<='#{self.distribution_date}' AND due_date>='#{self.distribution_date}' AND debts.name = 'Travel'")
    result.exists? ? result.first.boa_payment_due : 0
  end

  def cash
    result = DebtBalance.joins(:debt).where("payment_start_date<='#{self.distribution_date}' AND due_date>='#{self.distribution_date}' AND debts.name = 'Cash'")
    result.exists? ? result.first.boa_payment_due : 0
  end

  def express
    result = DebtBalance.joins(:debt).where("payment_start_date<='#{self.distribution_date}' AND due_date>='#{self.distribution_date}' AND debts.name = 'Express'")
    result.exists? ? result.first.boa_payment_due : 0
  end

  def jcp
    result = DebtBalance.joins(:debt).where("payment_start_date<='#{self.distribution_date}' AND due_date>='#{self.distribution_date}' AND debts.name = 'Jcp'")
    result.exists? ? result.first.boa_payment_due : 0
  end

  def amout_due(debt_name = nil, account = nil)
    if debt_name && account
      result = DebtBalance.joins(:debt).where("payment_start_date<='#{self.distribution_date}' AND due_date>='#{self.distribution_date}' AND debts.name = '#{debt_name}'")
      if result.exists?
        account == 'Chase' ? result.first.chase_payment_due : result.first.boa_payment_due
      end
    end
  end

  private
  def validate_date_is_friday
    errors.add(:distribution_date, "must be a Friday") unless self.distribution_date.wday == 5
  end

end
