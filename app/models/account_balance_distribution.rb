class AccountBalanceDistribution < ActiveRecord::Base
  belongs_to :account_balance
  belongs_to :debt
end
