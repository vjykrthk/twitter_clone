class CreateMicropostsTable < ActiveRecord::Migration
  def up
  	create_table :microposts do |t|
  		t.string :content
  		t.integer :user_id
  		t.timestamps
  	end
  end

  def down
  	drop_table :microposts
  end
end
