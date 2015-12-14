class IncomeSource < ActiveRecord::Base
  include DateModule
  
  validates_presence_of :name, :pay_schedule, :pay_day, :amount, :start_date, :end_date
  validates_numericality_of :amount
  
  validate :weekly_payday, :if => Proc.new{|k| k.pay_schedule == 'weekly'}
  validate :bi_weekly_payday, :if => Proc.new{|k| k.pay_schedule == 'bi-weekly'}
  validate :semi_monthly_pay, :if => Proc.new{|k| k.pay_schedule == 'semi-monthly'}
  validate :start_and_end
    
  def paychecks(from=Time.now.to_date, to=Time.now.to_date)
    from = [from, start_date].max
    to = [to, end_date].min
    result = []
    if pay_schedule == 'weekly'
      result = (from..to).to_a.select {|k| is_day_of_week(k, pay_day)}
    elsif pay_schedule == 'bi-weekly'
      result = (from..to).to_a.select {|k| is_day_of_week(k, pay_day) && k.cweek % 2 == start_date.cweek % 2}
    elsif pay_schedule == 'semi-monthly'
      result = (from..to).to_a.select {|k| is_day_of_month(k, pay_day.split(',')[0]) || is_day_of_month(k, pay_day.split(',')[1])}
    end
    result.count
  end
  
  def income(from=Time.now.to_date, to=Time.now.to_date)
    paychecks(from, to) * self.amount
  end
  
  def self.total_income(from=Time.now.to_date, to=Time.now.to_date)
    result = 0
    IncomeSource.all.each {|k| result += k.income(from,to)}
    result
  end
  
  private
  def bi_weekly_payday
      errors.add(:pay_day, "must be a valid day (#{days_of_week.join(', ')})") unless days_of_week.include?(pay_day.titleize)
      errors.add(:start_date, "must be a #{pay_day.titleize}") unless is_day_of_week(start_date, pay_day)
  end
  
  def weekly_payday
      errors.add(:pay_day, "must be a valid day (#{days_of_week.join(', ')})") unless days_of_week.include?(pay_day.titleize)
      errors.add(:start_date, "must be a #{pay_day.titleize}") unless is_day_of_week(start_date, pay_day)
  end
  
  def semi_monthly_pay
    if pay_day.split(',').size != 2
      errors.add(:pay_day, "must be a list of 2 elements. e.g. '1, 15' for 1st and 15th of each month. Days can be 'first' or 'last'.")
    else 
      pay_day.split(',').each do |k|
        if not (k.to_i >=1 || k.to_i <= 31 || ['first','last'].include?(k.strip.downcase))
          errors.add(:pay_day, "must be between the 1st and the 31st or 'first' or 'last'.")
        end
      end
    end
  end
  
  def start_and_end
    errors.add(:start_date, "must be before end date") unless is_before(start_date, end_date)
  end
end
