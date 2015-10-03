class IncomeDistribution < ActiveRecord::Base
  include DateModule

  validates_presence_of :distribution_date, :boa_chk, :chase_chk
  validates_numericality_of :boa_chk, :chase_chk
  validates_uniqueness_of :distribution_date

  validate :validate_date_is_friday

  RENT = 1550
  CAR_BASE_PAY_DAY = Date.new(2015,1,2)
  CAR_LOAN = 186.19

  CHASE_BASE_PAY_DAY = Date.new(2015,1,9)
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
    bi_weekly_due(CAR_BASE_PAY_DAY,self.distribution_date) ? CAR_LOAN : 0
  end

  def student_alloc
    result = 0
    student_loans.each {|loan| result += loan.chase_payment_due }
    bi_weekly_due(CHASE_BASE_PAY_DAY,self.distribution_date) ? result : 0
  end

  def student_loans
    bi_weekly_due(CHASE_BASE_PAY_DAY,self.distribution_date) ? DebtBalance.joins(:debt).where("payment_start_date<='#{self.distribution_date}' AND due_date>='#{self.distribution_date}' AND debts.sub_category = 'Student Loans'") : []
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
    amount_due('Amex')
  end

  def freedom
    amount_due('Freedom')
  end

  def travel
    amount_due('Travel')
  end

  def cash
    amount_due('Cash')
  end

  def express
    amount_due('Express')
  end

  def jcp
    amount_due('Jcp')
  end

  def credit_cards
    DebtBalance.joins(:debt).where("payment_start_date<='#{self.distribution_date}' AND due_date>='#{self.distribution_date}' AND debts.sub_category = 'Credit Cards'")
  end

  def amount_due(debt_name = nil)
    amount = 0
    if debt_name 
      result = DebtBalance.joins(:debt).where("payment_start_date<='#{self.distribution_date}' AND due_date>='#{self.distribution_date}' AND debts.name = '#{debt_name}'")
      if result.exists?
        amount = result.first.payment_due
      end
    end
    amount
  end

  def boa_debts
    DebtBalance.joins(:debt).where("payment_start_date<='#{self.distribution_date}' AND due_date>='#{self.distribution_date}' AND debts.pay_from = 'Bank Of America'")
  end

  def chase_debts
    DebtBalance.joins(:debt).where("payment_start_date<='#{self.distribution_date}' AND due_date>='#{self.distribution_date}' AND debts.pay_from = 'Chase'")
  end

  private
  def validate_date_is_friday
    errors.add(:distribution_date, "must be a Friday") unless self.distribution_date.wday == 5
  end

end
