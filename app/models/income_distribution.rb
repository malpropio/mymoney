class IncomeDistribution < ActiveRecord::Base
  include DateModule
  include IncomeDistributionsHelper
 
  validates_presence_of :distribution_date, :boa_chk, :chase_chk
  validates_numericality_of :boa_chk, :chase_chk
  validates_uniqueness_of :distribution_date

  validate :validate_date_is_friday, :if => Proc.new{|id| id.distribution_date < Date.new(2015,11,1)}
  validate :validate_date_is_nih_friday, :if => Proc.new{|id| id.distribution_date < Date.new(2015,11,1)}
  
  CHASE_BASE_PAY_DAY = Date.new(2015,1,9)
  BOA_BUFFER = 10
  CHASE_BUFFER = 10
  
  ONE_PAY_SCHEDULE = Date.new(2015,11,1)
  
  def debts(account=nil)
    if !account.nil?
      DebtBalance.joins(:debt).where("debt_balances.payment_start_date<='#{self.distribution_date}' 
                                      AND due_date>='#{self.distribution_date}' 
                                      AND (debts.pay_from = '#{account}' OR debts.name = '#{self.focus(account)}')")
    end
  end

  def focus(account=nil)
    if !account.nil?
      account=="Chase" ? self.chase_focus : self.boa_focus
    end
  end
  
  def checking(account=nil)
    if !account.nil?
      account=="Chase" ? self.chase_chk : self.boa_chk
    end
  end
  
  def debts_hash_dynamic(account=nil)
    result = {}
  
    if !account.nil?
	  left_over = self.focus(account)
	  left_over_total = self.checking(account)

	  result[account] = [self.checking(account), BOA_BUFFER, self.checking(account)]
	  left_over_total -= BOA_BUFFER
	
	  if left_over_total > 0
		  debts(account).map do |d|
			amount = d.payment_due(self.distribution_date)
			max_amount = d.max_payment(self.distribution_date)
			if d.debt.pay_from != account
			  max_amount -= debts_hash_dynamic(account=="Chase" ? "Bank Of America" : "Chase")[d.debt.name][1]
			end
			result[d.debt.name] = [amount, amount, max_amount]
			left_over_total -= amount unless d.debt.name == left_over
		  end
	  end

	  if !result[left_over].nil?
		  if left_over == account
			result[left_over][1] += left_over_total
		  else
			result[left_over][1] = [left_over_total,result[left_over][2]].min
			result[account][1] += (left_over_total - result[left_over][1]) #add diff between leftover and max payment allowed
		  end
	  end
    end
    result
  end

  def chase_debts_hash
    debts_hash_dynamic("Chase")
  end
  
  def boa_debts_hash
    debts_hash_dynamic("Bank Of America")
  end

  def debts_hash
      result = boa_debts_hash
      b = chase_debts_hash
      result = result.merge(b){ |k, a_value, b_value| [a_value[0], a_value[1] + b_value[1], a_value[2]] }
  end

  def boa_total_distribution
    total = 0
    boa_debts_hash.map{|k,v| total+=v[1].abs}
    total
  end

  def chase_total_distribution
    total = 0
    chase_debts_hash.map{|k,v| total+=v[1].abs}
    total
  end

  def total_chk
    self.chase_chk + self.boa_chk
  end

  def total_distribution
    boa_total_distribution + chase_total_distribution
  end

  def allocation(debt = nil)
    if debt
      debts_hash[debt] ? debts_hash[debt][1] : 0
    end
  end

  def allocations
    result = {}
    distro_list.map do |k,v| 
      if result[v[1]].nil?
        result[v[1]] = allocation(k)
      else
        result[v[1]] += allocation(k)
      end
    end
    result.sort
  end

  private
  def validate_date_is_friday
    errors.add(:distribution_date, "must be a Friday") unless self.distribution_date.wday == 5
  end
  
  def validate_date_is_nih_friday
    if self.distribution_date >= ONE_PAY_SCHEDULE && bi_weekly_due(CHASE_BASE_PAY_DAY,self.distribution_date)
      errors.add(:distribution_date, "is not a payday. Try next friday.")
    end
  end

end
