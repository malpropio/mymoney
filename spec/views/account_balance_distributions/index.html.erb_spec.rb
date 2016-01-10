require 'rails_helper'

RSpec.describe 'account_balance_distributions/index', type: :view do
  before(:each) do
    assign(:account_balance_distributions, [
      AccountBalanceDistribution.create!(
        account_balance: nil,
        debt: nil,
        recommendation: '9.99',
        actual: '9.99'
      ),
      AccountBalanceDistribution.create!(
        account_balance: nil,
        debt: nil,
        recommendation: '9.99',
        actual: '9.99'
      )
    ])
  end

  it 'renders a list of account_balance_distributions' do
    render
    assert_select 'tr>td', text: nil.to_s, count: 2
    assert_select 'tr>td', text: nil.to_s, count: 2
    assert_select 'tr>td', text: '9.99'.to_s, count: 2
    assert_select 'tr>td', text: '9.99'.to_s, count: 2
  end
end
