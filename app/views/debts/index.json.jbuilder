json.array!(@debts) do |debt|
  json.extract! debt, :id, :category, :sub_category, :name, :due_day
  json.url debt_url(debt, format: :json)
end
