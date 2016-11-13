require 'test_helper'

class AuctionTest < ActiveSupport::TestCase
  it 'does not allow lower amount bids' do
    auction.place_bid('uid2', 200)
    expect do
      auction.place_bid('uid3', 150)
    end.to raise_error(Errors.insufficient_bid_amount)
  end
end
