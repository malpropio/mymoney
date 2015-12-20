json.array!(@account_balance_distributions) do |account_balance_distribution|
  json.extract! account_balance_distribution, :id, :account_balance_id, :debt_id, :recommendation, :actual
  json.url account_balance_distribution_url(account_balance_distribution, format: :json)
end
