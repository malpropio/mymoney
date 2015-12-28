class AccountBalanceDistribution < ActiveRecord::Base
  belongs_to :account_balance
  belongs_to :debt

  def authorize(user=nil)
    self.account_balance.account.user.id == user.id
  end
end
