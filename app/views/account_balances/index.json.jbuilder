json.array!(@account_balances) do |account_balance|
  json.extract! account_balance, :id, :balance_date, :account_id, :amount, :buffer, :debt_id, :paid
  json.url account_balance_url(account_balance, format: :json)
end
