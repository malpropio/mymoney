require 'rails_helper'

RSpec.describe 'debt_balances/index', type: :view do
  before(:each) do
    assign(:debt_balances, [
      DebtBalance.create!(
        debt: nil,
        balance: 1.5
      ),
      DebtBalance.create!(
        debt: nil,
        balance: 1.5
      )
    ])
  end

  it 'renders a list of debt_balances' do
    render
    assert_select 'tr>td', text: nil.to_s, count: 2
    assert_select 'tr>td', text: 1.5.to_s, count: 2
  end
end
