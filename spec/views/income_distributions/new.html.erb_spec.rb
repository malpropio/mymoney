require 'rails_helper'

RSpec.describe "income_distributions/new", type: :view do
  before(:each) do
    assign(:income_distribution, IncomeDistribution.new(
      :amex => "9.99",
      :freedom => "9.99",
      :travel => "9.99",
      :cash => "9.99",
      :jcp => "9.99",
      :express => "9.99",
      :boa_chk => "9.99",
      :chase_chk => "9.99"
    ))
  end

  it "renders new income_distribution form" do
    render

    assert_select "form[action=?][method=?]", income_distributions_path, "post" do

      assert_select "input#income_distribution_amex[name=?]", "income_distribution[amex]"

      assert_select "input#income_distribution_freedom[name=?]", "income_distribution[freedom]"

      assert_select "input#income_distribution_travel[name=?]", "income_distribution[travel]"

      assert_select "input#income_distribution_cash[name=?]", "income_distribution[cash]"

      assert_select "input#income_distribution_jcp[name=?]", "income_distribution[jcp]"

      assert_select "input#income_distribution_express[name=?]", "income_distribution[express]"

      assert_select "input#income_distribution_boa_chk[name=?]", "income_distribution[boa_chk]"

      assert_select "input#income_distribution_chase_chk[name=?]", "income_distribution[chase_chk]"
    end
  end
end
