atom_feed do |feed|
	feed.title "Microposts by #{@user.name}"
	feed.updated @microposts.first.created_at

	@microposts.each do |micropost|
		feed.entry micropost, published:micropost.created_at do |entry|
			entry.title micropost.content
			entry.content micropost.content
			entry.author do |author|
				author.name @user.name
			end
		end
	end
end