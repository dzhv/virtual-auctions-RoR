class CreateAccounts < ActiveRecord::Migration[5.0]
  def change
    create_table :accounts do |t|
      t.decimal :balance, precision: 5, scale: 2

      t.timestamps
    end
  end
end
