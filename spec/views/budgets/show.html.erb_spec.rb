require 'rails_helper'

RSpec.describe 'budgets/show', type: :view do
  before(:each) do
    @budget = assign(:budget, Budget.create!(
                                category: nil,
                                amount: '9.99'
    ))
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(/9.99/)
  end
end
