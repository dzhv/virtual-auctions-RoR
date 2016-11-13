require 'rails_helper'
require_relative '../../app/errors/errors'

RSpec.describe Auction, type: 'model' do
  fixtures :auctions
  fixtures :users
  fixtures :bids
  let(:auction) { Auction.new }
  let(:first_user) { @jonas }
  let(:second_user) { User.new }
  let(:bike_auction) { @bike_auction }
  let(:dog_auction) { @dog_auction }

  it 'does not allow lower amount bids' do
    auction.place_bid(first_user, 200)
    expect do
      auction.place_bid(second_user, 150)
    end.to raise_error(Errors::InsufficientBidError)
  end

  it 'removes current bid on buyout' do
    bike_auction.place_bid(first_user, 200)
    bike_auction.buyout
    expect(bike_auction).not_to have_bid
  end

  it 'creates appropriate auction' do
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
      bike_auction.buyout
      expect(Auction.active).not_to include(bike_auction)
    end
  end
end
