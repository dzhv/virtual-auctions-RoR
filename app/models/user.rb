# System user
class User < ApplicationRecord
  has_one :account
  has_many :auction
  has_many :bid
end
