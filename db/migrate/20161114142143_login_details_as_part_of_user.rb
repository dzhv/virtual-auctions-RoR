class LoginDetailsAsPartOfUser < ActiveRecord::Migration[5.0]
  def change
    drop_table :logins
    add_column :users, :username, :string
    add_column :users, :password, :string
  end
end
