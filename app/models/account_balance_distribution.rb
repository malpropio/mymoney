class AccountBalanceDistribution < ActiveRecord::Base
  belongs_to :account_balance
  belongs_to :debt

  def authorize(user=nil)
    owner = self.account_balance.account.user
    owner.id == user.id || owner.contributors.where(id: user.id).exists? 
  end
end
