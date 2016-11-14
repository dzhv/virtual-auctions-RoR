require_relative '../errors/errors'

# System auction created by a user
class Auction < ApplicationRecord
  belongs_to :user
  has_one :item
  has_one :current_bid, foreign_key: 'auction_id',
                        class_name: 'Bid',
                        dependent: :destroy

  scope :by_user, ->(user_id) { where(user_id: user_id) }
  scope :active, -> { where(state: 'active') }

  after_initialize do
    if new_record?
      self.current_bid = Bid.empty
      self.state = 'active'
    end
  end

  def place_bid(user, bid_amount)
    if bid_amount < current_bid.amount
      raise Errors::InsufficientBidError.new, 'Bid is too low'
    end
    handle_bid_transactions(user, bid_amount)
  end

  def handle_bid_transactions(user, bid_amount)
    user.withdraw_money(bid_amount)
    refund_bidder
    self.current_bid = Bid.new(user: user, auction: self, amount: bid_amount)
  end

  def buyout(user)
    user.make_buyout_transaction(buyout_price)
    refund_bidder
    mark_as_bought
  end

  def refund_bidder
    current_bid.refund_bidder unless current_bid == Bid.empty
  end

  def mark_as_bought
    self.state = 'bought'
    build_current_bid(amount: 0)
    save!
  end

  def close
    if current_bid != Bid.empty
      raise Errors::NotAllowedError.new, 'Cannot close bidded auction'
    end
    self.state = 'closed'
    save!
  end

  def active?
    state == 'active'
  end
end
