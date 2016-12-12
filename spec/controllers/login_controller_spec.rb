require 'rails_helper'

RSpec.describe LoginController, type: :controller do
  fixtures :users
  let(:user) { users(:jonas) }
  let(:username) { 'username' }
  let(:password) { 'password' }

  describe 'GET #show' do
    it 'returns http success' do
      get :show
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #log_in' do
    subject(:action) do
      post :log_in, params: { username: username, password: password }
    end

    it 'redirects to user page on succesful login' do
      allow(User).to receive(:login).with(username, password).and_return(user)
      expect(action).to redirect_to(user_url(user))
    end

    it 'redirects to show on unsuccesful login' do
      allow(User).to receive(:login).with(username, password).and_raise(
        Errors::WrongCredentialsError, 'Wrong credentials'
      )
      expect(action).to redirect_to('/login/show?notice=Wrong+credentials')
    end
  end
end
