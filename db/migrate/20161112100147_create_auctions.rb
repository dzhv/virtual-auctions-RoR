class CreateAuctions < ActiveRecord::Migration[5.0]
  def change
    create_table :auctions do |t|
      t.references :user, foreign_key: true
      t.decimal :starting_price, precision: 5, scale: 2
      t.decimal :buyout_price, precision: 5, scale: 2
      t.string :state

      t.timestamps
    end
  end
end
