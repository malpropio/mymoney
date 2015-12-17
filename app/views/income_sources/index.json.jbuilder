json.array!(@income_sources) do |income_source|
  json.extract! income_source, :id, :name, :pay_schedule, :pay_day, :amount, :start_date, :end_date
  json.url income_source_url(income_source, format: :json)
end
