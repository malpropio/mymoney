require 'rails_helper'

RSpec.describe "spendings/index", type: :view do
  before(:each) do
    assign(:spendings, [
      Spending.create!(
        :description => "Description",
        :category => nil,
        :amount => "9.99"
      ),
      Spending.create!(
        :description => "Description",
        :category => nil,
        :amount => "9.99"
      )
    ])
  end

  it "renders a list of spendings" do
    render
    assert_select "tr>td", :text => "Description".to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
  end
end
