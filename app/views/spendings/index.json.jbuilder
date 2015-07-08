json.array!(@spendings) do |spending|
  json.extract! spending, :id, :description, :category_id, :spending_date, :amount
  json.url spending_url(spending, format: :json)
end
