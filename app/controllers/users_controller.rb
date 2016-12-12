# Users controller
class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit]

  # GET /users/1
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  def create
    user = User.new(user_params)
    return unless user.save
    respond_to do |format|
      format.html { redirect_to user }
    end
  end

  # PATCH/PUT /users/1
  def update
    user = find_user
    return unless user.update(user_params)
    respond_to do |format|
      format.html { redirect_to }
    end
  end

  # DELETE /users/1
  def destroy
    find_user.destroy
    respond_to do |format|
      format.html { redirect_to users_url }
    end
  end

  private

  def set_user
    @user = find_user
  end

  # Use callbacks to share common setup or constraints between actions.
  def find_user
    User.find(params.fetch(:id))
  end

  # Never trust parameters from the scary internet,
  # only allow the white list through.
  def user_params
    params.require(:user).permit(
      :first_name,
      :last_name,
      :email,
      :tel_no,
      :username,
      :password
    )
  end
end
