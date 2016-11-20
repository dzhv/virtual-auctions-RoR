# Auction bid
class Bid < ApplicationRecord
  belongs_to :user
  belongs_to :auction

  def self.empty
    bid = new
    bid.amount = 0
    bid
  end

  def ==(other)
    user.equal?(other.user) &&
      amount.eql?(other.amount)
  end

  def refund_bidder
    user.add_money(amount)
  end
end
