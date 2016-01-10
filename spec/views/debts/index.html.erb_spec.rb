require 'rails_helper'

RSpec.describe 'debts/index', type: :view do
  before(:each) do
    assign(:debts, [
      Debt.create!(
        category: 'Category',
        sub_category: 'Sub Category',
        name: 'Name',
        due_day: 1
      ),
      Debt.create!(
        category: 'Category',
        sub_category: 'Sub Category',
        name: 'Name',
        due_day: 1
      )
    ])
  end

  it 'renders a list of debts' do
    render
    assert_select 'tr>td', text: 'Category'.to_s, count: 2
    assert_select 'tr>td', text: 'Sub Category'.to_s, count: 2
    assert_select 'tr>td', text: 'Name'.to_s, count: 2
    assert_select 'tr>td', text: 1.to_s, count: 2
  end
end
