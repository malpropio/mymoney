require 'rails_helper'

RSpec.describe "spendings/edit", type: :view do
  before(:each) do
    @spending = assign(:spending, Spending.create!(
      :description => "MyString",
      :category => nil,
      :amount => "9.99"
    ))
  end

  it "renders the edit spending form" do
    render

    assert_select "form[action=?][method=?]", spending_path(@spending), "post" do

      assert_select "input#spending_description[name=?]", "spending[description]"

      assert_select "input#spending_category_id[name=?]", "spending[category_id]"

      assert_select "input#spending_amount[name=?]", "spending[amount]"
    end
  end
end
