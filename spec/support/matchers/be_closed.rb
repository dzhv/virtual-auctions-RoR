require 'rspec/expectations'
require_relative '../../rails_helper'

RSpec::Matchers.define :be_closed do
  match do |auction|
    auction.state == 'closed'
  end
end
