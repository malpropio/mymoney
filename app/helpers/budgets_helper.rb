module BudgetsHelper
  include DateModule

  THRESHOLD = '2015-10-01'

  def overall_budget(date = nil)
    start_date = date.nil? ? Date.new(1864, 1, 1) : date.change(day: 1)
    current_user.get_all('budgets').joins(:category).where("categories.name NOT IN ('Credit Cards')").where(budget_month: start_date).sum(:amount)
  end

  def overall_spending(date = nil)
    start_date = date.nil? ? Date.new(1864, 1, 1) : date.change(day: 1)
    current_user.real_spendings.where("DATE_FORMAT(spending_date,'%Y-%m-01') = '#{start_date}'").sum(:amount)
  end

  def credit_payment_budget(date = nil)
    result = 0
    current_user.get_all('debt_balances').where("debt_balances.payment_start_date<='#{date}' AND due_date>='#{date}'").each do |saving|
      if saving.debt.category.name == 'Credit Cards'
        result += saving.payment_due(date, false) * paychecks(saving.debt.account.name, date)
      end
    end
    result
  end

  def credit_payment_budget_notes(date = nil)
    result = 'Estimated payments needed to payoff all credit card balances: '
    current_user.get_all('debt_balances').where("debt_balances.payment_start_date<='#{date}' AND due_date>='#{date}'").each do |saving|
      if saving.debt.category.name == 'Credit Cards'
        result += "#{saving.debt.name} => #{number_to_currency(saving.payment_due(date, false))} x #{paychecks(saving.debt.account.name, date)}; "
      end
    end
    result
  end

  def potential_income(curr_month = nil)
    return if curr_month.nil?
    start_date = curr_month.beginning_of_month
    end_date = curr_month.end_of_month
    current_user.get_all('income_sources').total_income(nil, start_date, end_date)
  end

  def potential_income_notes(curr_month = nil)
    unless curr_month.nil?
      result = 'Expected income +/- 2 months: '
      result += "#{(curr_month - 2.month).strftime('%B %Y')} => #{number_to_currency(potential_income(curr_month - 2.month))}; "
      result += "#{(curr_month - 1.month).strftime('%B %Y')} => #{number_to_currency(potential_income(curr_month - 1.month))}; "
      result += "#{curr_month.strftime('%B %Y')} => #{number_to_currency(potential_income(curr_month))}; "
      result += "#{(curr_month + 1.month).strftime('%B %Y')} => #{number_to_currency(potential_income(curr_month + 1.month))}; "
      result += "#{(curr_month + 2.month).strftime('%B %Y')} => #{number_to_currency(potential_income(curr_month + 2.month))}"
    end
    result
  end

  def paychecks(account_name = nil, date = nil)
    start_date = date.nil? ? Date.new(1864, 1, 1) : date.change(day: 1)
    end_date = date.nil? ? Date.new(1864, 1, 1) : date.end_of_month
    if date < Date.new(2015, 10, 1)
      if account_name == 'Chase'
        chase_fridays(start_date, end_date)
      else
        boa_fridays(start_date, end_date)
      end
    else
      nih_fridays(start_date, end_date)
    end
  end
end
