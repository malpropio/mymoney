module IncomeDistributionsHelper

  def focus_hash(account = nil)
    result = {}
    Debt.where(pay_from: account).pluck(:name).map { |name| result[name] = name }
    if account == "Chase"
      result["Chase"] = "Chase"
    else
      result["BoA"] = "BoA"
      result["Rent"] = "Rent"
    end
    result
  end

  def distro_list
    result = {}

    Debt.pluck(:name).map { |name| result[name] = name }
    result["Rent"] = "Rent"

    result
  end
end
