require 'rails_helper'

RSpec.describe 'accounts/new', type: :view do
  before(:each) do
    assign(:account, Account.new(
                       user_id: 1,
                       name: 'MyString',
                       type: ''
    ))
  end

  it 'renders new account form' do
    render

    assert_select 'form[action=?][method=?]', accounts_path, 'post' do
      assert_select 'input#account_user_id[name=?]', 'account[user_id]'

      assert_select 'input#account_name[name=?]', 'account[name]'

      assert_select 'input#account_type[name=?]', 'account[type]'
    end
  end
end
