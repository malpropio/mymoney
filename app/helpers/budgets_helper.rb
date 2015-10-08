module BudgetsHelper
  include DateModule

  def overall_budget(date = nil)
    Budget.joins(:category).where("categories.name NOT IN ('Credit Cards')").where(budget_month: date).sum(:amount) 
  end

  def potential_income(curr_month = nil)
    if !curr_month.nil?
      start_date = curr_month.change(day: 1)
      end_date = curr_month.end_of_month
      chase_fridays(start_date,end_date) * 1837.09 + (boa_fridays(start_date,end_date)-chase_fridays(start_date,end_date)) * 1137.31
    end
  end
end
