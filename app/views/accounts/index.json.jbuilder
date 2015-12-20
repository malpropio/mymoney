json.array!(@accounts) do |account|
  json.extract! account, :id, :user_id, :name, :account_type
  json.url account_url(account, format: :json)
end
