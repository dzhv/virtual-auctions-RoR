# System user
class User < ApplicationRecord
  has_one :account
  has_many :auction
  has_many :bid

  after_initialize do
    self.account = Account.new if new_record?
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
