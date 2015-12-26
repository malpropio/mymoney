class Account < ActiveRecord::Base
  belongs_to :user
  has_many :income_sources
  has_many :account_balances
  has_many :debts
  attr_readonly :user

  def to_s
    self.name
  end

  def authorize(user=nil)
    owner = self.user
    owner.id == user.id || owner.contributors.where(id: user.id).exists?
  end

end
