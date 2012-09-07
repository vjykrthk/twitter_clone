class AddColumnRemembermeTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :rememberme_token, :string
  	add_index :users, :rememberme_token
  end
end
