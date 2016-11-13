class CreateBids < ActiveRecord::Migration[5.0]
  def change
    create_table :bids do |t|
      t.references :user, foreign_key: true
      t.decimal :amount, precision: 5, scale: 2
      t.references :auction, foreign_key: true

      t.timestamps
    end
  end
end
