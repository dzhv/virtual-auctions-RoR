require 'digest/sha1'

# System user
class User < ApplicationRecord
  has_one :account
  has_many :auction
  has_many :bid

  before_save do
    return unless new_record?
    self.account = Account.new
    self.password = Digest::SHA1.hexdigest(password)
  end

  def add_money(amount)
    account.add_money(amount)
  end

  def withdraw_money(amount)
    account.withdraw(amount)
  end

  def confirm_funds(amount)
    account.confirm_funds(amount)
  end

  def make_buyout_transaction(buyout_price)
    confirm_funds(buyout_price)
    withdraw_money(buyout_price)
  end
end
