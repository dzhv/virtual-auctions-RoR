class AssignAuctionToItem < ActiveRecord::Migration[5.0]
  def change
    add_reference :items, :auction, foreign_key: true
  end
end
