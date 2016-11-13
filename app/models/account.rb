# User system finance account
class Account < ApplicationRecord
  belongs_to :user

  def add_money(amount)
    self.balance += amount
  end

  def withdraw(amount)
    if amount > balance
      raise Errors::InsufficientFundsError.new, 'Withdraw is not allowed'
    end
    self.balance -= amount
  end
end
