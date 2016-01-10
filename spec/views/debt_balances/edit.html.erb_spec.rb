require 'rails_helper'

RSpec.describe 'debt_balances/edit', type: :view do
  before(:each) do
    @debt_balance = assign(:debt_balance, DebtBalance.create!(
                                            debt: nil,
                                            balance: 1.5
    ))
  end

  it 'renders the edit debt_balance form' do
    render

    assert_select 'form[action=?][method=?]', debt_balance_path(@debt_balance), 'post' do
      assert_select 'input#debt_balance_debt_id[name=?]', 'debt_balance[debt_id]'

      assert_select 'input#debt_balance_balance[name=?]', 'debt_balance[balance]'
    end
  end
end
