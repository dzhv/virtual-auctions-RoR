require_relative '../errors/errors'
require 'digest/sha1'

# Login controller
class LoginController < ApplicationController
  def show
    @username = ''
    @password = ''
    @notice = params[:notice]
  end

  def log_in
    user = User.login(params[:username], params[:password])
    login_succesful_responce(user)
  rescue Errors::WrongCredentialsError => error
    bad_credentials_responce(error)
  end

  private

  def login_succesful_responce(user)
    respond_to do |format|
      format.html { redirect_to user, notice: 'Login was succesful' }
    end
  end

  def bad_credentials_responce(error)
    respond_to do |format|
      format.html { redirect_to action: 'show', notice: error.message }
    end
  end
end
