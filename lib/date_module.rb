module DateModule
  def boa_fridays(start_date, end_date)
    my_days = [5] # day of the week in 0-6. Sunday is day-of-week 0; Saturday is day-of-week 6.
    result = (start_date..end_date).to_a.select {|k| my_days.include?(k.wday)}
    result.count
  end

  def chase_fridays(start_date, end_date)
    my_days = [5] # day of the week in 0-6. Sunday is day-of-week 0; Saturday is day-of-week 6.
    result = (start_date..end_date).to_a.select {|k| my_days.include?(k.wday) && k.cweek % 2 == 0}
    result.count
  end
end 
