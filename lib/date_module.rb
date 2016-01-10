module DateModule
  def boa_fridays(start_date, end_date)
    fridays = 0
    if start_date && end_date
      my_days = [5] # day of the week in 0-6. Sunday is day-of-week 0; Saturday is day-of-week 6.
      result = (start_date..end_date).to_a.select { |k| my_days.include?(k.wday) }
      fridays = result.count
    end
    fridays
  end

  def chase_fridays(start_date, end_date)
    fridays = 0
    if start_date && end_date
      my_days = [5] # day of the week in 0-6. Sunday is day-of-week 0; Saturday is day-of-week 6.
      result = (start_date..end_date).to_a.select { |k| my_days.include?(k.wday) && k.cweek.even? }
      fridays = result.count
    end
    fridays
  end

  def nih_fridays(start_date, end_date)
    fridays = 0
    if start_date && end_date
      my_days = [5] # day of the week in 0-6. Sunday is day-of-week 0; Saturday is day-of-week 6.
      result = (start_date..end_date).to_a.select { |k| my_days.include?(k.wday) && k.cweek.odd? }
      fridays = result.count
    end
    fridays
  end

  def verve_business_days(start_date, end_date)
    fridays = 0
    my_days = [1, 2, 3, 4, 5]
    if start_date && end_date
      result = (start_date..end_date).to_a.select { |k| my_days.include?(k.wday) }
      fridays = result.count
    end
    fridays
  end

  def verve_paychecks(start_date, end_date)
    if start_date && end_date
      result = (start_date..end_date).to_a.select { |k| k.day == 15 || k == k.end_of_month }
      result.count
    end
  end

  def bi_weekly_due(base_date, curr_date)
    reference_date = Date.new(2009, 1, 1)

    ref_count = boa_fridays(reference_date, base_date)
    curr_count = boa_fridays(reference_date, curr_date)

    (curr_count - ref_count).even?
  end

  def curr_month
    Time.now.to_date
  end

  def last_n_months(n = 12)
    end_date = curr_month.change(day: 1)
    end_date = 1.month.since end_date if (Time.now >= 1.month.from_now.change(day: 1) - 5.days)
    start_date = n.month.ago end_date
    (start_date..end_date).map { |k| [k.strftime('%b %Y'), k] if k.day == 1 }.compact.reverse!
  end

  def days_of_week
    end_date = Date.new(2015, 01, 04)
    start_date = 6.days.ago end_date
    (start_date..end_date).map { |k| k.strftime('%A').titleize }.compact
  end

  def before?(first, second)
    first < second
  end

  def day_of_week?(date, day)
    date.strftime('%A').titleize == day.titleize
  end

  def day_of_month?(date, day)
    day = day.downcase.strip
    if day == 'first'
      date == date.beginning_of_month
    elsif day == 'last'
      date == date.end_of_month
    else
      date.day == [day.to_i, date.end_of_month.day].min
    end
  end
end
