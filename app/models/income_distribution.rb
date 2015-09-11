class IncomeDistribution < ActiveRecord::Base

  validates_presence_of :distribution_date, :boa_chk, :chase_chk
  validates_numericality_of :boa_chk, :chase_chk
  validates_uniqueness_of :distribution_date

  validate :validate_date_is_friday

  SAVING = 1500
  RENT = 1550
  STUDENT_LOAN = 300
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

  def savings_alloc 
    SAVING/fridays 
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
    self.distribution_date.cweek % 2 == 0 ? STUDENT_LOAN : 0 
  end
  
  def rent_alloc
    (RENT*fridays_to_date)/fridays
  end

  def boa_balance_left
    self.boa_chk - boa_total_distribution + BOA_BUFFER
  end

  def chase_balance_left
    self.chase_chk - chase_total_distribution + CHASE_BUFFER
  end

  def amex
    result = DebtBalance.joins(:debt).where("due_date>'#{self.distribution_date}' AND due_date<='#{self.distribution_date + 30.days}' AND debts.name = 'Amex'")
    result.nil? ? 0 : result.count > 0 ? result.first.balance/fridays(result.first.due_date - 1.months, result.first.due_date) : 0
  end

  def freedom
    result = DebtBalance.joins(:debt).where("due_date>'#{self.distribution_date}' AND due_date<='#{self.distribution_date + 30.days}' AND debts.name = 'Freedom'")
    result.nil? ? 0 : result.count > 0 ? result.first.balance/chase_fridays(result.first.due_date - 1.months, result.first.due_date) : 0
  end

  def travel
    result = DebtBalance.joins(:debt).where("due_date>'#{self.distribution_date}' AND due_date<='#{self.distribution_date + 30.days}' AND debts.name = 'Travel'")
    result.nil? ? 0 : result.count > 0 ? result.first.balance/fridays(result.first.due_date - 1.months, result.first.due_date) : 0
  end

  def cash
    result = DebtBalance.joins(:debt).where("due_date>'#{self.distribution_date}' AND due_date<='#{self.distribution_date + 30.days}' AND debts.name = 'Cash'")
    result.nil? ? 0 : result.count > 0 ? result.first.balance/fridays(result.first.due_date - 1.months, result.first.due_date) : 0
  end

  def express
    result = DebtBalance.joins(:debt).where("due_date>'#{self.distribution_date}' AND due_date<='#{self.distribution_date + 30.days}' AND debts.name = 'Express'")
    result.nil? ? 0 : result.count > 0 ? result.first.balance/fridays(result.first.due_date - 1.months, result.first.due_date) : 0
  end

  def jcp
    result = DebtBalance.joins(:debt).where("due_date>'#{self.distribution_date}' AND due_date<='#{self.distribution_date + 30.days}' AND debts.name = 'Jcp'")
    result.nil? ? 0 : result.count > 0 ? result.first.balance/fridays(result.first.due_date - 1.months, result.first.due_date) : 0
  end

  private
  def fridays(start_arg = nil, end_arg = nil)
    start_date = start_arg || self.distribution_date.at_beginning_of_month # your start
    end_date = end_arg || self.distribution_date.at_end_of_month # your end
    my_days = [5] # day of the week in 0-6. Sunday is day-of-week 0; Saturday is day-of-week 6.
    result = (start_date..end_date).to_a.select {|k| my_days.include?(k.wday)}
    result.count
  end

  def fridays_to_date(start_arg = nil)
    start_date = start_arg || self.distribution_date.at_beginning_of_month # your start
    end_date = self.distribution_date# your end
    my_days = [5] # day of the week in 0-6. Sunday is day-of-week 0; Saturday is day-of-week 6.
    result = (start_date..end_date).to_a.select {|k| my_days.include?(k.wday)}
    result.count
  end

  def chase_fridays(start_arg = nil, end_arg = nil)
    start_date = start_arg || self.distribution_date.at_beginning_of_month # your start
    end_date = end_arg || self.distribution_date.at_end_of_month # your end
    my_days = [5] # day of the week in 0-6. Sunday is day-of-week 0; Saturday is day-of-week 6.
    result = (start_date..end_date).to_a.select {|k| my_days.include?(k.wday) && k.cweek % 2 == 0}
    result.count
  end

  def chase_fridays_to_date(start_arg = nil)
    start_date = start_arg || self.distribution_date.at_beginning_of_month # your start
    end_date = self.distribution_date# your end
    my_days = [5] # day of the week in 0-6. Sunday is day-of-week 0; Saturday is day-of-week 6.
    result = (start_date..end_date).to_a.select {|k| my_days.include?(k.wday) && k.cweek % 2 == 0}
    result.count
  end

  def validate_date_is_friday
    errors.add(:distribution_date, "must be a Friday") unless self.distribution_date.wday == 5
  end

end
