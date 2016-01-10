require 'rails_helper'

RSpec.describe 'debts/new', type: :view do
  before(:each) do
    assign(:debt, Debt.new(
                    category: 'MyString',
                    sub_category: 'MyString',
                    name: 'MyString',
                    due_day: 1
    ))
  end

  it 'renders new debt form' do
    render

    assert_select 'form[action=?][method=?]', debts_path, 'post' do
      assert_select 'input#debt_category[name=?]', 'debt[category]'

      assert_select 'input#debt_sub_category[name=?]', 'debt[sub_category]'

      assert_select 'input#debt_name[name=?]', 'debt[name]'

      assert_select 'input#debt_due_day[name=?]', 'debt[due_day]'
    end
  end
end
