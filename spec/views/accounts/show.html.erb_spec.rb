require 'rails_helper'

RSpec.describe 'accounts/show', type: :view do
  before(:each) do
    @account = assign(:account, Account.create!(
                                  user_id: 1,
                                  name: 'Name',
                                  type: 'Type'
    ))
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/1/)
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Type/)
  end
end
