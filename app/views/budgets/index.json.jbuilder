json.array!(@budgets) do |budget|
  json.extract! budget, :id, :category_id, :budget_month, :amount
  json.url budget_url(budget, format: :json)
end
