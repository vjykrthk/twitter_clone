class AddColumnEmailCofirmationToUsers < ActiveRecord::Migration
  def change
    add_column :users, :confirmation_code, :string
    add_column :users, :confirmation_code_send_at, :datetime
    add_column :users, :email_confirmed, :boolean, :default => false
  end
end
