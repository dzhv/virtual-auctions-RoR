require 'rails_helper'
require_relative '../../app/errors/errors'

describe User do
  fixtures :users
  let(:prototype_user) { @jonas }
  let(:password) { 'password' }
  let(:username) { 'username' }
  let(:user) do
    user_data = prototype_user.attributes
    user_data[:id] = SecureRandom.uuid
    user_data[:password] = password
    user_data[:username] = username
    described_class.create(user_data)
    described_class.find(user_data[:id])
  end

  it 'is assigned an account' do
    expect(user.account).to be_a(Account)
  end

  it 'is assigned an empty account' do
    expect(user.account.balance).to eq(0)
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

  it 'is assigned a login' do
    expect(user.username).to eq(username)
  end

  it 'it\'s password is hashed' do
    expect(user.password).to be_hashed(password)
  end
end
