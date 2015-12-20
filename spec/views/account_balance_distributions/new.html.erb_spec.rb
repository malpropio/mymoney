require 'rails_helper'

RSpec.describe "account_balance_distributions/new", type: :view do
  before(:each) do
    assign(:account_balance_distribution, AccountBalanceDistribution.new(
      :account_balance => nil,
      :debt => nil,
      :recommendation => "9.99",
      :actual => "9.99"
    ))
  end

  it "renders new account_balance_distribution form" do
    render

    assert_select "form[action=?][method=?]", account_balance_distributions_path, "post" do

      assert_select "input#account_balance_distribution_account_balance_id[name=?]", "account_balance_distribution[account_balance_id]"

      assert_select "input#account_balance_distribution_debt_id[name=?]", "account_balance_distribution[debt_id]"

      assert_select "input#account_balance_distribution_recommendation[name=?]", "account_balance_distribution[recommendation]"

      assert_select "input#account_balance_distribution_actual[name=?]", "account_balance_distribution[actual]"
    end
  end
end
