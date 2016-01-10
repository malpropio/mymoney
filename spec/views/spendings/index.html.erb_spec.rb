require 'rails_helper'

RSpec.describe 'spendings/index', type: :view do
  before(:each) do
    assign(:spendings, [
      Spending.create!(
        description: 'Description',
        category: Category.create!(name: 'uncategorized', description: 'Description'),
        amount: '9.99',
        spending_date: DateTime.new(2001, 2, 3)
      ),
      Spending.create!(
        description: 'Description',
        category: Category.create!(name: 'uncategorized', description: 'Description'),
        amount: '9.99',
        spending_date: DateTime.new(2001, 2, 3)
      )
    ])
  end

  it 'renders a list of spendings' do
    allow(view).to receive_messages(will_paginate: nil)
    render
    assert_select 'tr>td', text: 'Description'.to_s, count: 2
    assert_select 'tr>td', text: 'uncategorized'.to_s, count: 2
    assert_select 'tr>td', text: '$9.99'.to_s, count: 2
    assert_select 'tr>td', text: '2001-02-03'.to_s, count: 2
  end
end
