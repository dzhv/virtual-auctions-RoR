require 'rails_helper'

RSpec.describe 'users/edit', type: :view do
  let(:user) do
    User.create!(
      first_name: 'MyString',
      last_name: 'MyString',
      email: 'MyString',
      tel_no: 'MyString',
      username: 'MyString',
      password: 'MyString'
    )
  end
  before(:each) do
    @user = assign(:user, user)
  end

  it 'renders the edit user form' do
    render

    assert_select 'form[action=?][method=?]', user_path(user), 'post' do
      assert_select 'input#user_first_name[name=?]', 'user[first_name]'
      assert_select 'input#user_last_name[name=?]', 'user[last_name]'
      assert_select 'input#user_email[name=?]', 'user[email]'
      assert_select 'input#user_tel_no[name=?]', 'user[tel_no]'
      assert_select 'input#user_username[name=?]', 'user[username]'
    end
  end
end
