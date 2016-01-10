require 'rails_helper'

RSpec.describe 'spendings/new', type: :view do
  before(:each) do
    assign(:spending, Spending.new(
                        description: 'MyString',
                        category: nil,
                        amount: '9.99'
    ))
  end

  it 'renders new spending form' do
    render

    assert_select 'form[action=?][method=?]', spendings_path, 'post' do
      assert_select 'input#spending_description[name=?]', 'spending[description]'

      assert_select 'select#spending_category_id[name=?]', 'spending[category_id]'

      assert_select 'input#spending_amount[name=?]', 'spending[amount]'

      assert_select 'input#spending_spending_date[name=?]', 'spending[spending_date]'
    end
  end
end
