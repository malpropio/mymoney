require 'rails_helper'

RSpec.describe 'users/edit', type: :view do
  before(:each) do
    @user = assign(:user, User.create!(
                            first_name: 'MyString',
                            last_name: 'MyString',
                            email: 'MyString@gmail.com',
                            username: 'MyString',
                            password: 'MyString',
                            password_confirmation: 'MyString'
    ))
  end

  it 'renders the edit user form' do
    render

    assert_select 'form[action=?][method=?]', user_path(@user), 'post' do
      assert_select 'input#user_first_name[name=?]', 'user[first_name]'

      assert_select 'input#user_last_name[name=?]', 'user[last_name]'

      assert_select 'input#user_email[name=?]', 'user[email]'

      assert_select 'input#user_username[name=?]', 'user[username]'

      assert_select 'input#user_password[name=?]', 'user[password]'

      assert_select 'input#user_password_confirmation[name=?]', 'user[password_confirmation]'
    end
  end
end
