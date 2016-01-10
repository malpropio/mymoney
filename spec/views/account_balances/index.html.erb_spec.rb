require 'rails_helper'

RSpec.describe 'account_balances/index', type: :view do
  before(:each) do
    assign(:account_balances, [
      AccountBalance.create!(
        account: nil,
        amount: '9.99',
        buffer: '9.99',
        debt: nil,
        paid: false
      ),
      AccountBalance.create!(
        account: nil,
        amount: '9.99',
        buffer: '9.99',
        debt: nil,
        paid: false
      )
    ])
  end

  it 'renders a list of account_balances' do
    render
    assert_select 'tr>td', text: nil.to_s, count: 2
    assert_select 'tr>td', text: '9.99'.to_s, count: 2
    assert_select 'tr>td', text: '9.99'.to_s, count: 2
    assert_select 'tr>td', text: nil.to_s, count: 2
    assert_select 'tr>td', text: false.to_s, count: 2
  end
end
