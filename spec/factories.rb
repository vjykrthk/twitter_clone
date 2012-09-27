FactoryGirl.define do
	factory :user do
		sequence(:name) { |n| "Person-#{n}"}
		sequence(:email) { |n| "person-#{n}@gmail.com"}
		password "foobar"
		password_confirmation "foobar"
		email_confirmed true
		factory :admin do
			admin true
		end	
	end

	factory :micropost do
		content "Lorem ipsum"
		user
	end
end