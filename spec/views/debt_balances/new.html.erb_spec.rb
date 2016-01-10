require 'rails_helper'

RSpec.describe 'debt_balances/new', type: :view do
  before(:each) do
    assign(:debt_balance, DebtBalance.new(
                            debt: nil,
                            balance: 1.5
    ))
  end

  it 'renders new debt_balance form' do
    render

    assert_select 'form[action=?][method=?]', debt_balances_path, 'post' do
      assert_select 'input#debt_balance_debt_id[name=?]', 'debt_balance[debt_id]'

      assert_select 'input#debt_balance_balance[name=?]', 'debt_balance[balance]'
    end
  end
end
