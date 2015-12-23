json.array!(@debts) do |debt|
  json.extract! debt, :id, :category, :old_category, :sub_category, :name, :is_asset
  json.url debt_url(debt, format: :json)
end
