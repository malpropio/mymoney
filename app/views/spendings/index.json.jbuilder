json.array!(@spendings) do |spending|
  json.extract! spending, :id, :description, :category_id, :spending_date_ts, :amount, :name
  json.url spending_url(spending, format: :json)
end
