require 'rails_helper'
require 'digest/sha1'

RSpec.describe UsersController, type: :controller do
  let(:valid_attributes) do
    {
      password: 'password',
      first_name: 'first name',
      last_name: 'last name',
      email: 'email@email.email',
      tel_no: '30203030',
      username: 'user name'
    }
  end

  let(:invalid_attributes) do
    {
      username: 'username'
    }
  end

  let(:valid_session) { {} }

  describe 'GET #show' do
    it 'assigns the requested user as @user' do
      user = User.create! valid_attributes
      get :show, params: { id: user.to_param }
      expect(assigns(:user)).to eq(user)
    end
  end

  describe 'GET #new' do
    it 'assigns a new user as @user' do
      get :new
      expect(assigns(:user)).to be_a_new(User)
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested user as @user' do
      user = User.create! valid_attributes
      get :edit, params: { id: user.to_param }
      expect(assigns(:user)).to eq(user)
    end
  end

  describe 'POST #create' do
    context 'on succesfull save' do
      it 'creates a new User' do
        expect do
          post :create, params: { user: valid_attributes }
        end.to change(User, :count).by(1)
      end

      it 'creates User with all attributes' do
        post :create, params: { user: valid_attributes }
        valid_attributes[:password] = Digest::SHA1.hexdigest(
          valid_attributes[:password]
        )
        expect(User.last).to have_attributes(valid_attributes)
      end

      it 'redirects to the created user' do
        post :create, params: { user: valid_attributes }
        expect(response).to redirect_to(User.last)
      end
    end

    context 'on failed save' do
      it 'stays on the same page' do
        user_double = double
        allow(User).to receive(:new) { user_double }
        allow(user_double).to receive(:save) { false }
        expect(controller).to receive(:redirect_to).exactly(0).times

        post :create, params: { user: invalid_attributes }
      end
    end
  end

  describe 'PUT #update' do
    let(:new_attributes) do
      {
        last_name: 'last name',
        email: 'email@gmail.com',
        tel_no: '300030'
      }
    end

    context 'on succesfull save' do
      it 'updates the requested user' do
        user = User.create! valid_attributes
        put :update, params: { id: user.to_param, user: new_attributes }
        user.reload
        expect(user).to have_attributes(new_attributes)
      end

      it 'redirects to the user' do
        user = User.create! valid_attributes
        put :update, params: { id: user.to_param, user: new_attributes }
        expect(response).to redirect_to(user)
      end
    end

    context 'on failed save' do
      it 'stays on the same page' do
        id = '1'
        user_double = double
        allow(User).to receive(:find).with(id) { user_double }
        allow(user_double).to receive(:update) { false }
        expect(controller).to receive(:redirect_to).exactly(0).times

        post :update, params: { id: id, user: new_attributes }
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested user' do
      user = User.create! valid_attributes
      expect do
        delete :destroy, params: { id: user.to_param }
      end.to change(User, :count).by(-1)
    end

    it 'redirects to the users list' do
      user = User.create! valid_attributes
      delete :destroy, params: { id: user.to_param }
      expect(response).to redirect_to(users_url)
    end
  end
end
