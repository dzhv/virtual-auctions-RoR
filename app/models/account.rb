# User system finance account
class Account < ApplicationRecord
  belongs_to :user

  def add_money(amount)
    self.balance += amount
    save!
  end

  def withdraw(amount)
    confirm_funds(amount)
    self.balance -= amount
    save!
  end

  def confirm_funds(amount)
    return if balance >= amount
    raise Errors::InsufficientFundsError.new, 'Insufficient funds'
  end
end
