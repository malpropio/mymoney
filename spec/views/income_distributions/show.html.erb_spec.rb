require 'rails_helper'

RSpec.describe "income_distributions/show", type: :view do
  before(:each) do
    @income_distribution = assign(:income_distribution, IncomeDistribution.create!(
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

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/9.99/)
    expect(rendered).to match(/9.99/)
    expect(rendered).to match(/9.99/)
    expect(rendered).to match(/9.99/)
    expect(rendered).to match(/9.99/)
    expect(rendered).to match(/9.99/)
    expect(rendered).to match(/9.99/)
    expect(rendered).to match(/9.99/)
  end
end
