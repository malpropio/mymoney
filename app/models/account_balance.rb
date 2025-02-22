class AccountBalance < ActiveRecord::Base
  belongs_to :account
  belongs_to :debt

  has_many :account_balance_distributions

  attr_accessor :total_distribution

  def authorize(user = nil)
    owner = account.user
    owner.id == user.id || owner.contributors.where(id: user.id).exists?
  end

  def debts
    DebtBalance.joins(:debt).where("debt_balances.payment_start_date<='#{balance_date}'
                                      AND due_date>='#{balance_date}'
                                      AND (debts.account_id = '#{account.id}' OR debts.id = '#{debt.id}')")
  end

  def recommendations
    recommendations = AccountBalance.all_recommendations(balance_date)
    other_pays = 0
    recommendations.each do |key, value|
      if key != account.name && key == debt.account.name
        other_pays += value[debt.name][1] unless value[debt.name].nil?
      end
    end
    unless recommendations[account.name][debt.name].nil?
      recommendations[account.name][debt.name][2] -= other_pays
      original = recommendations[account.name][debt.name][1]
      new_debt = [recommendations[account.name][debt.name][2], original].min
      recommendations[account.name][debt.name][1] = new_debt
      recommendations[account.name][account.name][1] += original - new_debt
    end
    self.total_distribution = recommendations[account.name].map { |_k, v| v[1] }.reduce(0, :+)
    if total_distribution < amount
      recommendations[account.name][account.name][1] += amount - total_distribution
    end
    recommendations[account.name]
  end

  def make_payments
    recommendations.each do |rec|
      unless Debt.do_not_pay_list.include? rec[0]
        new_debt = Debt.find_by(name: rec[0], deleted_at: nil)
        AccountBalanceDistribution.create(recommendation: rec[1][0], actual: rec[1][1], debt_id: new_debt.id, account_balance_id: id) unless rec[1][1] == 0
      end
    end
    update(paid: true)
  end

  def undo_payments
    account_balance_distributions.each(&:destroy)
    update(paid: false)
  end

  def self.all_recommendations(date)
    all_balances = AccountBalance.where(balance_date: date)

    overall_result = {}

    if all_balances.exists?
      all_balances.each do |balance|
        result = {}
        left_over = balance.debt.name # focus
        left_over_total = balance.amount # checking amount

        result[balance.account.name] = [balance.amount, balance.buffer, balance.amount]
        left_over_total -= balance.buffer

        if left_over_total > 0
          balance.debts.map do |d|
            max_amount = [d.max_payment(balance.balance_date), 0].max
            recommendation = [d.payment_due(balance.balance_date), 0].max
            actual = [max_amount, recommendation].min
            result[d.debt.name] = [recommendation, actual, max_amount]
            left_over_total -= actual unless d.debt.name == left_over
          end
        end

        unless result[left_over].nil?
          if left_over == balance.account.name
            result[left_over][1] += left_over_total
          else
            result[left_over][1] = [left_over_total, result[left_over][2]].min
            result[balance.account.name][1] += (left_over_total - result[left_over][1]) # add diff between leftover and max payment allowed
          end
        end

        total = 0
        result.map { |_k, v| total += v[1].abs }
        balance.total_distribution = total
        overall_result[balance.account.name] = result
      end
    end
    overall_result
  end

  def to_s
    "#{balance_date}: #{account}"
  end
end
