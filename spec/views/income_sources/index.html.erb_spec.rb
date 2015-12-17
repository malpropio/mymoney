require 'rails_helper'

RSpec.describe "income_sources/index", type: :view do
  before(:each) do
    assign(:income_sources, [
      IncomeSource.create!(
        :name => "Name",
        :pay_schedule => "Pay Schedule",
        :pay_day => "Pay Day",
        :amount => 1.5
      ),
      IncomeSource.create!(
        :name => "Name",
        :pay_schedule => "Pay Schedule",
        :pay_day => "Pay Day",
        :amount => 1.5
      )
    ])
  end

  it "renders a list of income_sources" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Pay Schedule".to_s, :count => 2
    assert_select "tr>td", :text => "Pay Day".to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
  end
end
