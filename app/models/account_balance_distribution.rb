class AccountBalanceDistribution < ActiveRecord::Base
  belongs_to :account_balance
  delegate :balance_date, to: :account_balance, prefix: true, allow_nil: true

  belongs_to :debt

  def authorize(user = nil)
    owner = account_balance.account.user
    owner.id == user.id || owner.contributors.where(id: user.id).exists?
  end
end
