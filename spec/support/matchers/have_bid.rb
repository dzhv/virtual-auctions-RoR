require 'rspec/expectations'
require_relative '../../rails_helper'

RSpec::Matchers.define :have_bid do
  match do |auction|
    auction.current_bid != Bid.empty
  end
end
