require 'rails_helper'

RSpec.describe 'debt_balances/show', type: :view do
  before(:each) do
    @debt_balance = assign(:debt_balance, DebtBalance.create!(
                                            debt: nil,
                                            balance: 1.5
    ))
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(/1.5/)
  end
end
