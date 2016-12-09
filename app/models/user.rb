require 'digest/sha1'
require_relative '../errors/errors'

# System user
class User < ApplicationRecord
  has_one :account
  has_many :auction
  has_many :bid

  scope :by_credentials, (lambda do |username, password|
    where(username: username, password: password)
  end)

  before_save do
    configure_new_user if new_record?
  end

  def add_money(amount)
    account.add_money(amount)
  end

  def withdraw_money(amount)
    account.withdraw(amount)
  end

  def make_buyout_transaction(buyout_price)
    withdraw_money(buyout_price)
  end

  def self.login(username, password)
    hashed_password = Digest::SHA1.hexdigest(password)
    user = by_credentials(username, hashed_password).first
    unless user
      raise Errors::WrongCredentialsError, 'Wrong username or password'
    end
    user
  end

  private

  def configure_new_user
    self.account = Account.new
    self.password = Digest::SHA1.hexdigest(password)
  end
end
