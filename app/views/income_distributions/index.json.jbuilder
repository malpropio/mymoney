json.array!(@income_distributions) do |income_distribution|
  json.extract! income_distribution, :id, :distribution_date, :boa_chk, :chase_chk
  json.url income_distribution_url(income_distribution, format: :json)
end
