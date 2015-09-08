require 'rails_helper'

RSpec.describe "income_distributions/index", type: :view do
  before(:each) do
    assign(:income_distributions, [
      IncomeDistribution.create!(
        :amex => "9.99",
        :freedom => "9.99",
        :travel => "9.99",
        :cash => "9.99",
        :jcp => "9.99",
        :express => "9.99",
        :boa_chk => "9.99",
        :chase_chk => "9.99"
      ),
      IncomeDistribution.create!(
        :amex => "9.99",
        :freedom => "9.99",
        :travel => "9.99",
        :cash => "9.99",
        :jcp => "9.99",
        :express => "9.99",
        :boa_chk => "9.99",
        :chase_chk => "9.99"
      )
    ])
  end

  it "renders a list of income_distributions" do
    render
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
  end
end
