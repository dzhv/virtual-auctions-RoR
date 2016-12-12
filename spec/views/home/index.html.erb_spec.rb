require 'rails_helper'

RSpec.describe 'home/index.html.erb', type: :view do
  it 'renders Log in button' do
    render

    assert_select("input[value='Log in']") do |elements|
      expect(elements.length).to eq(1)
    end
  end

  it 'renders Sign up button' do
    render

    assert_select("input[value='Sign up']") do |elements|
      expect(elements.length).to eq(1)
    end
  end
end
