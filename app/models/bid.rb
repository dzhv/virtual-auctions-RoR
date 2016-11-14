# Auction bid
class Bid < ApplicationRecord
  belongs_to :user
  belongs_to :auction

  def self.empty
    bid = Bid.new
    bid.amount = 0
    bid
  end

  def ==(other)
    user == other.user &&
      amount == other.amount
  end

  def refund_bidder
    user.add_money(amount)
  end
end
