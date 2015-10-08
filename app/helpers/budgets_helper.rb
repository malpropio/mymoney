module BudgetsHelper
  include DateModule

  def overall_budget(date = nil)
    Budget.joins(:category).where("categories.name NOT IN ('Credit Cards')").where(budget_month: date).sum(:amount) 
  end

  def student_loan_budget(date = nil)
    savings = DebtBalance.joins(:debt).where("payment_start_date<='#{date}' AND due_date>='#{date}' AND debts.sub_category = 'Student Loans'")
    result = 0
    if savings.exists?
      savings.each {|saving| result += saving.payment_due * paychecks(saving.debt.pay_from,date)  }
    end
    result
  end

  def car_loan_budget(date = nil)
    start_date = date.nil? ? Date.new(1864,1,1) : date.change(day: 1)
    end_date = date.nil? ? Date.new(1864,1,1) : date.end_of_month
    186.19 * (boa_fridays(start_date,end_date)-chase_fridays(start_date,end_date))
  end

  def savings_budget(date = nil)
    savings = DebtBalance.joins(:debt).where("payment_start_date<='#{date}' AND due_date>='#{date}' AND debts.sub_category = 'Savings'")
    result = 0
    if savings.exists?
      savings.each {|saving| result += saving.payment_due * paychecks(saving.debt.pay_from,date)  }
    end
    result
  end

  def loans_budget(date = nil)
    car_loan_budget(date)+student_loan_budget(date)
  end

  def fixed_budget(date = nil)
    result = 0
    result += Budget.joins(:category)
                   .where("categories.name NOT IN ('Credit Cards')")
                   .where("categories.name IN ('Rent','Utilities','Insurance','Phone/TV/Internet')")
                   .where(budget_month: date)
                   .sum(:amount)

    result += savings_budget(date)
    result += loans_budget(date)

    result
  end

  def variable_budget(date = nil)
    overall_budget(date)-fixed_budget(date)
  end

  def potential_income(curr_month = nil)
    if !curr_month.nil?
      start_date = curr_month.change(day: 1)
      end_date = curr_month.end_of_month
      chase_fridays(start_date,end_date) * 1837.09 + (boa_fridays(start_date,end_date)-chase_fridays(start_date,end_date)) * 1137.31
    end
  end

  def paychecks(pay_from = nil, date = nil)
     start_date = date.nil? ? Date.new(1864,1,1) : date.change(day: 1)
     end_date = date.nil? ? Date.new(1864,1,1) : date.end_of_month
     if pay_from == "Chase"
       chase_fridays(start_date,end_date)
     else
       boa_fridays(start_date,end_date)
     end
  end
end
