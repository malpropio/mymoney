require 'rails_helper'

RSpec.describe 'budgets/edit', type: :view do
  before(:each) do
    @budget = assign(:budget, Budget.create!(
                                category: nil,
                                amount: '9.99'
    ))
  end

  it 'renders the edit budget form' do
    render

    assert_select 'form[action=?][method=?]', budget_path(@budget), 'post' do
      assert_select 'input#budget_category_id[name=?]', 'budget[category_id]'

      assert_select 'input#budget_amount[name=?]', 'budget[amount]'
    end
  end
end
