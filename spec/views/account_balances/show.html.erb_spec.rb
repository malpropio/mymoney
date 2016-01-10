require 'rails_helper'

RSpec.describe 'account_balances/show', type: :view do
  before(:each) do
    @account_balance = assign(:account_balance, AccountBalance.create!(
                                                  account: nil,
                                                  amount: '9.99',
                                                  buffer: '9.99',
                                                  debt: nil,
                                                  paid: false
    ))
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(/9.99/)
    expect(rendered).to match(/9.99/)
    expect(rendered).to match(//)
    expect(rendered).to match(/false/)
  end
end
