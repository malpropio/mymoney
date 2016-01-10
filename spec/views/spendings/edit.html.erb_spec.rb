require 'rails_helper'

RSpec.describe 'spendings/edit', type: :view do
  before(:each) do
    @spending = assign(:spending, Spending.create!(
                                    description: 'MyString',
                                    category: Category.create!(name: 'uncategorized', description: 'Description'),
                                    amount: '9.99',
                                    spending_date: DateTime.new(2001, 2, 3)
    ))
  end

  it 'renders the edit spending form' do
    render

    assert_select 'form[action=?][method=?]', spending_path(@spending), 'post' do
      assert_select 'input#spending_description[name=?]', 'spending[description]'

      assert_select 'select#spending_category_id[name=?]', 'spending[category_id]'

      assert_select 'input#spending_amount[name=?]', 'spending[amount]'

      assert_select 'input#spending_spending_date[name=?]', 'spending[spending_date]'
    end
  end
end
