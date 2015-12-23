require 'rails_helper'

RSpec.describe "account_balances/new", type: :view do
  before(:each) do
    assign(:account_balance, AccountBalance.new(
      :account => nil,
      :amount => "9.99",
      :buffer => "9.99",
      :debt => nil,
      :paid => false
    ))
  end

  it "renders new account_balance form" do
    render

    assert_select "form[action=?][method=?]", account_balances_path, "post" do

      assert_select "input#account_balance_account_id[name=?]", "account_balance[account_id]"

      assert_select "input#account_balance_amount[name=?]", "account_balance[amount]"

      assert_select "input#account_balance_buffer[name=?]", "account_balance[buffer]"

      assert_select "input#account_balance_debt_id[name=?]", "account_balance[debt_id]"

      assert_select "input#account_balance_paid[name=?]", "account_balance[paid]"
    end
  end
end
