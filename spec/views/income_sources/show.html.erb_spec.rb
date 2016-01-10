require 'rails_helper'

RSpec.describe 'income_sources/show', type: :view do
  before(:each) do
    @income_source = assign(:income_source, IncomeSource.create!(
                                              name: 'Name',
                                              pay_schedule: 'Pay Schedule',
                                              pay_day: 'Pay Day',
                                              amount: 1.5
    ))
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Pay Schedule/)
    expect(rendered).to match(/Pay Day/)
    expect(rendered).to match(/1.5/)
  end
end
