require 'rails_helper'

RSpec.describe "spendings/show", type: :view do
  before(:each) do
    @spending = assign(:spending, Spending.create!(
      :description => "Description",
      :category => nil,
      :amount => "9.99"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Description/)
    expect(rendered).to match(//)
    expect(rendered).to match(/9.99/)
  end
end
