require 'rails_helper'

RSpec.describe 'budgets/new', type: :view do
  before(:each) do
    assign(:budget, Budget.new(
                      category: nil,
                      amount: '9.99'
    ))
  end

  it 'renders new budget form' do
    render

    assert_select 'form[action=?][method=?]', budgets_path, 'post' do
      assert_select 'input#budget_category_id[name=?]', 'budget[category_id]'

      assert_select 'input#budget_amount[name=?]', 'budget[amount]'
    end
  end
end
