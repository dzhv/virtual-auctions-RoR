require 'rails_helper'
require_relative '../../app/errors/errors'
require 'digest/sha1'

describe User do
  fixtures :users
  let(:prototype_user) { users(:jonas) }
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

  context 'on buyout transaction' do
    let(:buyout_amount) { 1000 }

    it 'withdraws money when sufficient funds' do
      user.add_money(buyout_amount)
      initial_balance = user.account.balance

      user.make_buyout_transaction(buyout_amount)
      expect(user.account.balance).to eq(initial_balance - buyout_amount)
    end

    it 'does not withdraw money when insufficient funds' do
      expect do
        user.make_buyout_transaction(buyout_amount)
      end.to raise_error(Errors::InsufficientFundsError)
    end
  end

  it 'can login' do
    user
    logged_in_user = described_class.login(username, password)
    expect(logged_in_user.id).to eq(user.id)
  end

  it 'does not allow to login with bad password' do
    user
    expect do
      described_class.login(username, 'bad password')
    end.to raise_error(
      Errors::WrongCredentialsError,
      'Wrong username or password'
    )
  end
end
