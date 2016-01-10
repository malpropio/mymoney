class IncomeSource < ActiveRecord::Base
  include DateModule

  belongs_to :account
  delegate :name, to: :account, prefix: true, allow_nil: true

  validates_presence_of :name, :pay_schedule, :pay_day, :amount, :start_date, :end_date, :account
  validates_numericality_of :amount

  validate :weekly_payday, if: proc { |k| k.pay_schedule == 'weekly' }
  validate :bi_weekly_payday, if: proc { |k| k.pay_schedule == 'bi-weekly' }
  validate :semi_monthly_pay, if: proc { |k| k.pay_schedule == 'semi-monthly' }
  validate :start_and_end

  def authorize(user = nil)
    owner = account.user
    owner.id == user.id || owner.contributors.where(id: user.id).exists?
  end

  def paydays
    if pay_schedule == 'weekly' || pay_schedule == 'bi-weekly'
      pay_day.titleize
    else
      pay_day.split(',').map { |word| word.to_i > 0 ? word.to_i.ordinalize : word.titleize }.join(' and ')
    end
  end

  def paychecks(from = Time.now.to_date, to = Time.now.to_date)
    from = [from, start_date].max
    to = [to, end_date].min
    result = []
    if pay_schedule == 'weekly'
      result = (from..to).to_a.select { |k| day_of_week?(k, pay_day) }
    elsif pay_schedule == 'bi-weekly'
      result = (from..to).to_a.select { |k| day_of_week?(k, pay_day) && (k - start_date) % 14 == 0 }
    elsif pay_schedule == 'semi-monthly'
      result = (from..to).to_a.select { |k| day_of_month?(k, pay_day.split(',')[0]) || day_of_month?(k, pay_day.split(',')[1]) }
    end
    result
  end

  def income(from = Time.now.to_date, to = Time.now.to_date)
    paychecks(from, to).size * amount
  end

  def self.total_income(source_account = nil, from = Date.new(2010, 1, 1), to = Time.now.to_date)
    result = 0
    if source_account.nil?
      IncomeSource.all.each { |k| result += k.income(from, to) }
    else
      IncomeSource.where(account_id: source_account.id).each { |k| result += k.income(from, to) }
    end
    result
  end

  def self.total_paychecks(source_account = nil, from = Date.new(2010, 1, 1), to = Time.now.to_date)
    result = []
    if source_account.nil?
      IncomeSource.all.each { |k| result += k.paychecks(from, to) }
    else
      IncomeSource.where(account_id: source_account.id).each { |k| result += k.paychecks(from, to) }
    end
    result.uniq.size
  end

  def self.max_end_date
    IncomeSource.maximum(:end_date)
  end

  private

  def bi_weekly_payday
    if start_date && end_date && pay_day
      errors.add(:pay_day, "must be a valid day (#{days_of_week.join(', ')})") unless days_of_week.include?(pay_day.titleize)
      errors.add(:start_date, "must be a #{pay_day.titleize}") unless day_of_week?(start_date, pay_day)
      errors.add(:end_date, "must be a #{pay_day.titleize}") unless day_of_week?(end_date, pay_day)
    end
  end

  def weekly_payday
    if start_date && end_date && pay_day
      errors.add(:pay_day, "must be a valid day (#{days_of_week.join(', ')})") unless days_of_week.include?(pay_day.titleize)
      errors.add(:start_date, "must be a #{pay_day.titleize}") unless day_of_week?(start_date, pay_day)
      errors.add(:end_date, "must be a #{pay_day.titleize}") unless day_of_week?(end_date, pay_day)
    end
  end

  def semi_monthly_pay
    if start_date && end_date && pay_day
      if pay_day.split(',').size != 2
        errors.add(:pay_day, "must be a list of 2 elements. e.g. '1, 15' for 1st and 15th of each month. Days can be 'first' or 'last'.")
      else
        pay_day.split(',').each do |k|
          unless (k.to_i >= 1 && k.to_i <= 31) || %w(first last).include?(k.strip.downcase)
            errors.add(:pay_day, "must be between the 1st and the 31st or 'first' or 'last'.")
          end
        end
      end
    end
  end

  def start_and_end
    if start_date && end_date
      errors.add(:start_date, 'must be before end date') unless before?(start_date, end_date)
    end
  end
end
