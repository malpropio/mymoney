class DebtBalance < ActiveRecord::Base
  include DateModule

  belongs_to :debt
  delegate :name, :schedule, :fix_amount, to: :debt, prefix: true, allow_nil: true

  has_many :spendings

  validates_presence_of :debt_id, :due_date, :balance
  validates :balance, numericality: true

  validates_uniqueness_of :debt_id, scope: :due_date, message: 'balance already due on this date'
  validate :start_pay_date

  before_validation do
    self.payment_start_date = due_date - 1.months + 1.days if !due_date.blank? && payment_start_date.blank?
  end

  def to_s
    debt.name
  end

  def authorize(user = nil)
    owner = debt.account.user
    owner.id == user.id || owner.contributors.where(id: user.id).exists?
  end

  def payments(up_to_date = nil, inclusive = false)
    comparison = inclusive ? '<=' : '<'
    threshold = "AND spending_date#{comparison}'#{up_to_date}'" unless up_to_date.nil?
    spendings.where("spending_date>='#{payment_start_date}' AND spending_date<='#{due_date}' #{threshold}")
  end

  def balance_of_interest
    (target_balance - balance).abs
  end

  def payment_due(payment_date = nil, _live = true)
    result = 0
    if debt.fix_amount
      if debt.schedule == 'Bi-Weekly'
        result = bi_weekly_due(debt.payment_start_date, payment_date) ? debt.fix_amount : 0
      elsif debt.schedule == 'Monthly'
        debt_account = debt.account
        paychecks_todate = debt.account.user.get_all('income_sources').total_paychecks(debt_account, payment_date.at_beginning_of_month, payment_date)
        paychecks_all = debt.account.user.get_all('income_sources').total_paychecks(debt_account, payment_date.at_beginning_of_month, payment_date.at_end_of_month)
        result = (debt.fix_amount * paychecks_todate) / paychecks_all unless paychecks_all == 0
      end
    else
      paychecks_all = debt.account.user.get_all('income_sources').total_paychecks(debt.account, payment_start_date, due_date)
      result = balance_of_interest / paychecks_all unless paychecks_all == 0
    end
    result
  end

  def after_pay_balance(up_to_date = nil, inclusive = false)
    if debt.is_asset?
      balance + payments(up_to_date, inclusive).sum(:amount)
    else
      balance - payments(up_to_date, inclusive).sum(:amount)
    end
  end

  def max_payment(up_to_date = nil, inclusive = false)
    if debt.is_asset?
      (target_balance - after_pay_balance(up_to_date, inclusive)).round(2)
    else
      (after_pay_balance(up_to_date, inclusive) - target_balance).round(2)
    end
  end

  def close
    if debt.is_asset?
      new_target_balance = balance + (payment_due * payments_to_date)
    else
      new_target_balance = balance - (payment_due * payments_to_date)
    end

    update_attribute(:target_balance, new_target_balance)
    update_attribute(:due_date, Time.now.to_date)
  end

  def in_payment?(date = Time.now.to_date)
    payment_start_date <= date && date <= due_date
  end

  def self.search_by_date(date)
    date = Time.now.to_date if date.nil?
    where("payment_start_date <= '#{date}' && '#{date}' <= due_date")
  end

  def self.search(search)
    if search
      search[:debt_id].blank? ? all : where(debt_id: search[:debt_id])
    else
      all
    end
  end

  private

  def start_pay_date
    if DebtBalance.where("id != #{id || 0} AND debt_id = #{debt_id} AND '#{payment_start_date}' <= due_date AND '#{due_date}' > due_date").exists?
      previous = DebtBalance.where("id != #{id || 0} AND debt_id = #{debt_id} AND '#{payment_start_date}' <= due_date AND '#{due_date}' > due_date").order(due_date:  'desc').first
      errors.add(:payment_start_date, "must be after #{previous.due_date}.")
    end

    if DebtBalance.where("id != #{id || 0} AND debt_id = #{debt_id} AND '#{payment_start_date}' >= payment_start_date AND '#{payment_start_date}' <= due_date").exists?
      goal = DebtBalance.where("id != #{id || 0} AND debt_id = #{debt_id} AND '#{payment_start_date}' >= payment_start_date AND '#{payment_start_date}' <= due_date").order(due_date:  'desc').first
      errors.add(:goal, "already set between #{goal.payment_start_date} and #{goal.due_date}")
    end

    if DebtBalance.where("id != #{id || 0} AND debt_id = #{debt_id} AND '#{due_date}' >= payment_start_date AND '#{due_date}' <= due_date").exists?
      goal = DebtBalance.where("id != #{id || 0} AND debt_id = #{debt_id} AND '#{due_date}' >= payment_start_date AND '#{due_date}' <= due_date").order(due_date:  'desc').first
      errors.add(:goal, "already set between #{goal.payment_start_date} and #{goal.due_date}")
    end

    return unless !due_date.blank? && !payment_start_date.blank?
    if due_date < payment_start_date
      errors.add(:payment_start_date, "(#{payment_start_date}) must be before due date (#{due_date})")
    end
  end
end
