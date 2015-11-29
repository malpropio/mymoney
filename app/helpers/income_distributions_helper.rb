module IncomeDistributionsHelper

  def focus_hash(account = nil)
    result = {}
    #Debt.where(pay_from: account).pluck(:name).map { |name| result[name] = name }
    Debt.where(deleted_at: nil).pluck(:name).map { |name| result[name] = name }
    result[account] = account #checking account
    result
  end

  def distro_list
    result = {}
    Debt.all.map { |d| result[d.name] = [d.name,d.category] }
    result
  end

  def distro_list_categories
    result = {}
    distro_list.map {|d| result[d[1][1]] = [d[1][1]]}
    result.sort
  end
end
