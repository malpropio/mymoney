class Account < ActiveRecord::Base
  belongs_to :user
  has_many :income_sources
  has_many :account_balances
  has_many :debts
  attr_readonly :user

  def to_s
    self.name
  end

end
