require 'rails_helper'
require_relative '../../app/errors/errors'

describe User do
  fixtures :users
  let(:user) do
    user_data = @jonas.attributes
    user_data[:id] = SecureRandom.uuid
    described_class.create(user_data)
  end

  it 'is assigned an account' do
    expect(user.account).to be_a(Account)
  end

  it 'can add money to account' do
    balance_before_increase = user.account.balance
    amount = 100
    user.add_money(amount)
    expect(user.account.balance).to eq(balance_before_increase + amount)
  end

  it 'can withdraw money from account' do
    balance = 100
    user.add_money(balance)
    withdraw_amount = 50

    user.withdraw_money(withdraw_amount)
    expect(user.account.balance).to eq(balance - withdraw_amount)
  end
end
