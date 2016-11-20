require 'rails_helper'
require_relative '../../app/errors/errors'

RSpec.describe Auction, type: 'model' do
  fixtures :auctions
  fixtures :users
  fixtures :bids
  fixtures :accounts
  let(:auction) { Auction.new }
  let(:first_user) { users(:jonas) }
  let(:initial_first_user_balance) { first_user.account.balance }
  let(:second_user) { users(:antanas) }
  let(:initial_second_user_balance) { second_user.account.balance }
  let(:bike_auction) { auctions(:bike_auction) }
  let(:dog_auction) { auctions(:dog_auction) }

  it 'does not allow lower amount bids' do
    auction.place_bid(first_user, 200)
    expect do
      auction.place_bid(second_user, 150)
    end.to raise_error(Errors::InsufficientBidError, 'Bid is too low')
  end

  it 'does not allow same amount bids' do
    auction.place_bid(first_user, 200)
    expect do
      auction.place_bid(second_user, 200)
    end.to raise_error(Errors::InsufficientBidError, 'Bid is too low')
  end

  it 'is appropriately created' do
    auction_data = bike_auction.attributes
    auction_data[:id] = SecureRandom.uuid
    auction = Auction.create(auction_data)
    expect(auction).to have_attributes(
      starting_price:  100,
      buyout_price:  250,
      state: 'active'
    )
  end

  context 'when auctions are retrieved' do
    it 'can list user auctions' do
      auctions = Auction.by_user(bike_auction.user_id)
      expect(auctions).to match_array([bike_auction])
    end

    it 'can get all auctions' do
      all_auctions = Auction.all
      expect(all_auctions).to match_array([bike_auction, dog_auction])
    end

    it 'active auctions do not include bought ones' do
      bike_auction.mark_as_bought
      expect(Auction.active).not_to include(bike_auction)
    end
  end

  context 'on bidding' do
    before(:each) do
      initial_first_user_balance
      bike_auction.place_bid(first_user, 50)
    end
    context 'on first bid' do
      it 'reduces bidder\'s account balance' do
        bidder = User.find(first_user.id)
        expect(bidder.account.balance).to eq(initial_first_user_balance - 50)
      end

      it 'persists the bid' do
        bidded_auction = Auction.find(bike_auction.id)
        expect(bidded_auction.current_bid).to have_attributes(
          user_id: first_user.id,
          amount: 50,
          auction_id: bidded_auction.id
        )
      end
    end

    it 'returns money for overthrown bidder' do
      bike_auction.place_bid(second_user, 200)

      overthrown_bidder = User.find(first_user.id)
      expect(overthrown_bidder.account.balance).to eq(
        initial_first_user_balance
      )
    end
  end

  context 'on buyout' do
    let(:buyer) { second_user }
    before(:each) do
      bike_auction.place_bid(first_user, 100)
      initial_second_user_balance
      bike_auction.buyout(buyer)
    end

    it 'reduces buyer\'s balance' do
      user = User.find(buyer.id)
      expected_amount = initial_second_user_balance - bike_auction.buyout_price
      expect(user.account.balance).to eq(expected_amount)
    end

    it 'removes current bid' do
      expect(bike_auction).not_to have_bid
    end

    it 'is marked as bought' do
      auction = Auction.find(bike_auction.id)
      expect(auction).to have_attributes(
        state: 'bought'
      )
    end
  end

  it 'refunds bidder on buyout' do
    bike_auction.place_bid(first_user, 100)
    expect(bike_auction.current_bid).to receive(:refund_bidder)
    bike_auction.buyout(second_user)
  end

  it 'can not be bought with insufficient funds' do
    allow(first_user.account).to receive(:balance) { 0 }
    expect do
      bike_auction.buyout(first_user)
    end.to raise_error(Errors::InsufficientFundsError)
  end

  context 'on auction close' do
    it 'can be closed' do
      dog_auction.close
      auction = Auction.find(dog_auction.id)
      expect(auction).to be_closed
    end

    it 'cannot be closed if bidded' do
      bike_auction.place_bid(first_user, 100)
      expect do
        bike_auction.close
      end.to raise_error(
        Errors::NotAllowedError,
        'Cannot close bidded auction'
      )
    end
  end
end
