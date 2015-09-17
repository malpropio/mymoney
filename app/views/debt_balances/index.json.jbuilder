json.array!(@debt_balances) do |debt_balance|
  json.extract! debt_balance, :id, :debt_id, :balance_month, :balance, :target_balance
  json.url debt_balance_url(debt_balance, format: :json)
end
