require 'rails_helper'

RSpec.describe 'login/show.html.erb', type: :view do
  it 'renders login form' do
    render
    assert_select 'form[action=?][method=?]', sign_in_path, 'post' do
      assert_select 'input#username'
      assert_select 'input#password'
    end
  end

  it 'renders Sign in button' do
    render
    assert_select("input[value='Sign in']") do |elements|
      expect(elements.length).to eq(1)
    end
  end
end
