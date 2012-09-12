namespace :db do
	desc "Populate the database"
	task populate: :environment do
		user = User.create!(name:"Vijay Karthik", email:"example@railstutorial.com", password:"foobar", password_confirmation:"foobar")
		user.toggle!(:admin)
		99.times do |n|
			name = Faker::Name.name
			email = "example-#{n+1}@railstutorial.org"
			password = "foobar"
			User.create!(name:name, email:email, password:password, password_confirmation:password)
		end
		users = User.all(limit: 6)
		50.times do
			content = Faker::Lorem.sentence(5)
			users.each do |user|
				user.microposts.create!(content:content)
			end
		end
	end
end