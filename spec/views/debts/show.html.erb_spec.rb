require 'rails_helper'

RSpec.describe 'debts/show', type: :view do
  before(:each) do
    @debt = assign(:debt, Debt.create!(
                            category: 'Category',
                            sub_category: 'Sub Category',
                            name: 'Name',
                            due_day: 1
    ))
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/Category/)
    expect(rendered).to match(/Sub Category/)
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/1/)
  end
end
