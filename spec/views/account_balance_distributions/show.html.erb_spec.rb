require 'rails_helper'

RSpec.describe "account_balance_distributions/show", type: :view do
  before(:each) do
    @account_balance_distribution = assign(:account_balance_distribution, AccountBalanceDistribution.create!(
      :account_balance => nil,
      :debt => nil,
      :recommendation => "9.99",
      :actual => "9.99"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(/9.99/)
    expect(rendered).to match(/9.99/)
  end
end
