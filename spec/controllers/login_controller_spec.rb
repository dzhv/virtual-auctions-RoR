require 'rails_helper'

RSpec.describe LoginController, type: :controller do

  describe "GET #show" do
    it "returns http success" do
      get :show
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #log_in" do
    it "returns http success" do
      get :log_in
      expect(response).to have_http_status(:success)
    end
  end

end
