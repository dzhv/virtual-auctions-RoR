class DefaultAccountBalanceValue < ActiveRecord::Migration[5.0]
  def change
    change_column :accounts, :balance, :decimal, precision: 5, scale: 2, default: 0
  end
end
