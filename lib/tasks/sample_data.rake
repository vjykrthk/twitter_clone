namespace :db do
	desc "Populate the database"
	task populate: :environment do
		user_sample_data
		micropost_sample_data
		users_followed_followers	
	end

	def user_sample_data
		user = User.create!(name:"Vijay Karthik", email:"example@railstutorial.com", password:"foobar", password_confirmation:"foobar")
		user.toggle!(:admin)
		99.times do |n|
			name = Faker::Name.name
			email = "example-#{n+1}@railstutorial.org"
			password = "foobar"
			User.create!(name:name, email:email, password:password, password_confirmation:password)
		end
	end

	def micropost_sample_data
		users = User.all(limit: 6)
		50.times do
			content = Faker::Lorem.sentence(5)
			users.each do |user|
				user.microposts.create!(content:content)
			end
		end
	end

	def users_followed_followers
		users = User.all
		user = users.first
		followed_users = users[3..30]
		followers = users[4..20]
		followed_users.each do |followed|
			user.follow!(followed)
		end
		followers.each do |follower|
			follower.follow!(user)
		end
	end
end