require 'rails_helper'
require_relative '../../app/errors/errors'

describe Bid do
  fixtures :users

  let(:first_bid) { described_class.empty }
  let(:second_bid) { described_class.empty }
  let(:user) { users(:jonas) }
  let(:user2) { users(:jonas) }

  it 'empty has 0 as amount' do
    empty_bid = described_class.empty
    expect(empty_bid.amount).to eq(0)
  end

  context 'when equality is compared' do
    before(:each) do
      first_bid.user = user
      first_bid.amount = 100
    end
    it 'is equal when user and amount is equal' do
      second_bid.user = user2
      second_bid.amount = 100
      expect(first_bid == second_bid).to be true
    end

    it 'is not equal when users are different' do
      second_bid.amount = 100
      expect(first_bid == second_bid).to be false
    end

    it 'is not equal when amounts are different' do
      second_bid.amount = 150
      second_bid.user = user
      expect(first_bid == second_bid).to be false
    end
  end

  it 'can refund bidder' do
    bid = described_class.new(user: user, amount: 150)
    initial_balance = user.account.balance
    bid.refund_bidder
    expect(user.account.balance).to eq(initial_balance + 150)
  end
end
