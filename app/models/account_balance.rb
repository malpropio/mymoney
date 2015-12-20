class AccountBalance < ActiveRecord::Base
  belongs_to :account
  belongs_to :debt

  has_many :account_balance_distributions

  def make_recommendations
    result = {}

	  left_over = self.debt.name #focus
	  left_over_total = self.amount #checking amount

	  result[account.name] = [self.amount, self.buffer, self.amount]
	  left_over_total -= self.buffer

	  if left_over_total > 0
		debts.map do |d|
		  amount = d.payment_due(self.balance_date)
		  max_amount = d.max_payment(self.balance_date)
		  result[d.debt.name] = [amount, amount, max_amount]
		  left_over_total -= amount unless d.debt.name == left_over
		end
	  end

	  if !result[left_over].nil?
		if left_over == account.name
		  result[left_over][1] += left_over_total
		else
		  result[left_over][1] = [left_over_total,result[left_over][2]].min
		  result[account.name][1] += (left_over_total - result[left_over][1]) #add diff between leftover and max payment allowed
		end
	  end
    result
  end

  def debts
    DebtBalance.joins(:debt).where("debt_balances.payment_start_date<='#{balance_date}'
                                      AND due_date>='#{balance_date}'
                                      AND (debts.account_id = '#{debt.account.id}' OR debts.id = '#{self.debt.id}')")
  end

  def to_s
    "#{balance_date.to_s}: #{account}"
  end
end
