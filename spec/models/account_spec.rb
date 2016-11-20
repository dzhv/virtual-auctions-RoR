require 'rails_helper'
require_relative '../../app/errors/errors'

describe Account do
  fixtures :users

  let(:user) { users(:jonas) }
  let(:account) { described_class.new(user: user) }

  it 'new account is empty' do
    expect(account.balance).to eq(0)
  end

  context 'when insufficient funds' do
    let(:balance_before_withdraw) { 50 }
    let(:withdraw_amount) { 100 }
    before(:each) do
      allow(account).to receive(:save!) { true }
      account.add_money(balance_before_withdraw)
    end

    it 'does not allow to withdraw' do
      expect do
        account.withdraw(withdraw_amount)
      end.to raise_error(Errors::InsufficientFundsError, 'Insufficient funds')
    end
  end

  it 'saves money adjustments' do
    expect(account).to receive(:save!).twice { true }
    account.add_money(100)
    account.withdraw(100)
  end

  it 'reduces correct amount of money on withdraw' do
    account.add_money(200)
    account.withdraw(75)
    expect(account.balance).to eq(125)
  end
end
