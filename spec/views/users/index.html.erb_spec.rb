require 'rails_helper'

RSpec.describe 'users/index', type: :view do
  before(:each) do
    assign(:users, [
      User.create!(
        first_name: 'First Name',
        last_name: 'Last Name',
        email: 'Email@gmail.com',
        username: 'Username_1',
        password_digest: 'Password Digest'
      ),
      User.create!(
        first_name: 'First Name',
        last_name: 'Last Name',
        email: 'Email_2@gmail.com',
        username: 'Username_2',
        password_digest: 'Password Digest'
      )
    ])
  end

  it 'renders a list of users' do
    render
    assert_select 'tr>td', text: 'First Name'.to_s, count: 2
    assert_select 'tr>td', text: 'Last Name'.to_s, count: 2
    # assert_select "tr>td", :text => "Email@gmail.com".to_s, :count => 2
    # assert_select "tr>td", :text => "Username_1".to_s, :count => 1
  end
end
