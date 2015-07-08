require 'rails_helper'

RSpec.describe Spending, type: :model do
  it "should have the necessary required validators" do
    spending = Spending.create(:description => "",:category_id => nil,:amount => "",:spending_date => nil)
    expect(spending.errors).to have_key(:description)
    expect(spending.errors).to have_key(:category_id)
    expect(spending.errors).to have_key(:amount)
    expect(spending.errors).to have_key(:spending_date)
  end

  it "amount must be a number" do
    spending = Spending.create(:description => "",:category_id => nil,:amount => "asdc",:spending_date => nil)
    expect(spending.errors).to have_key(:amount)
  end

end
