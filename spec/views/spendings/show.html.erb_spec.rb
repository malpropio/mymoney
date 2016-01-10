require 'rails_helper'

RSpec.describe 'spendings/show', type: :view do
  before(:each) do
    @spending = assign(:spending, Spending.create!(
                                    description: 'Description',
                                    category: Category.create!(name: 'uncategorized', description: 'Description'),
                                    amount: '9.99',
                                    spending_date: DateTime.new(2001, 2, 3)
    ))
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/Description/)
    expect(rendered).to match(/uncategorized/)
    expect(rendered).to match(/9.99/)
    expect(rendered).to match(/2001-02-03/)
  end
end
