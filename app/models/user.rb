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
end
