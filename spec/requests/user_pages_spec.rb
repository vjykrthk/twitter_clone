require 'spec_helper'

describe "User Pages" do

	subject { page }
	
	describe "signup path" do
		before { visit signup_path }
		it { should have_selector('h1', text:'Sign Up')}
		it { should have_selector('title', text:full_title("Sign up"))}
	end



	describe "Profile path" do
		let(:user) { FactoryGirl.create(:user) }
		let!(:m1) { FactoryGirl.create(:micropost, user:user)}
		let!(:m2) { FactoryGirl.create(:micropost, user:user)}
		
		before do
			signin_user(user) 
			visit user_path(user) 
		end
		it { should have_selector('title', text:user.name) }
		it { should have_selector('h1', text:user.name) }
		it { should have_content(m1.content) }
		it { should have_content(m2.content) }
		it { should have_content(user.microposts.count)}

		describe "following and follower user buttons" do
			let(:other_user) { FactoryGirl.create(:user) }
			describe "following action" do
				before { visit user_path(other_user) }

					it "increment the following count" do
						expect do
							click_button 'follow'
						end.to change(user.followed_users, :count).by(1)						
					end
				
				
					it "increment the following count" do
						expect do
							click_button 'follow'
						end.to change(other_user.followers, :count).by(1)
					end
				

				describe "Should render the unfollow form" do
					before { click_button 'follow'}
					it { should have_selector('input', value:"unfollow")}
				end
			end

			describe "unfollowing action" do
				before do 
					user.follow!(other_user)
					visit user_path(other_user) 
				end
				
				
				it "decrement the following count" do
					expect do
						click_button 'unfollow'
					end.to change(user.followed_users, :count).by(-1)
				end
				
				
				it "decrement the following count" do
					expect do
						click_button 'unfollow'
					end.to change(other_user.followers, :count).by(-1)
				end

				describe "Should render the follow form" do
					before { click_button 'unfollow'}
					it { should have_selector('input', value:"follow")}
				end
			end
		end

	end

	describe "Edit" do
		let(:user) { FactoryGirl.create(:user) }
		before { signin_user(user) }
		describe "Edit path" do			
			before { visit edit_user_path(user) }
			it { should have_selector('title', text:"Edit user") }
			it { should have_selector('h1', text:"Edit user") }
			it { should have_link 'Change', href:"http://gravatar.com/emails"}
		end
		
		describe "Invalid form submission" do
			before do 
				visit edit_user_path(user)
				click_button "Update"
			end
			it { should have_selector('h1', text:"Edit user") }
			it { should have_selector('div#error_explanation', text:"errors") }

		end

		describe "Valid form submission" do
			let(:new_name) { "name"}
			let(:new_email) { "email@email.com"}
			before do
				visit edit_user_path(user)
				fill_in "Name", with:new_name
				fill_in "Email", with:new_email
				fill_in "Password", with:user.password
				fill_in "Confirm password", with:user.password
				click_button "Update"
			end
			it { should have_selector('h1', text:new_name) }
			it { should have_selector('div.alert-success') }
			specify { user.reload.name == new_name }
			specify { user.reload.email == new_email } 
		end
	end
	


	describe "Index" do
		before do
			signin_user(FactoryGirl.create(:user))
			visit users_path
		end 
		it { should have_selector('h1', text:'All users')}				
		it { should have_selector('title', text:'All users') }
		

		describe "Pagination" do
			before(:all) { 30.times { FactoryGirl.create(:user) }}
			after(:all) { User.delete_all }
			it "Should have list of all users" do
				User.paginate(page: 1) do |user|
					should have_selector('li', text:user.name)
					should_not have_link('delete', href:user_path(user))
				end
			end
		end		
	end

	describe "delete link" do
		before(:all) { 30.times { FactoryGirl.create(:user) }}
		after(:all) { User.delete_all }
		it { should_not have_link('delete') }
		describe "as admin user" do
			let(:admin) { FactoryGirl.create(:admin) }
			before do
				signin_user admin
				visit users_path
			end
			it { should have_link 'delete', href:user_path(User.first) }
			it "Should be able to delete a user" do
				expect { click_link('delete') }.to change(User, :count).by(-1)
			end
			it { should_not have_link('delete', href:user_path(admin))}
		end
	end

	describe "User registration failure" do
		before do
			visit signup_path
		end
		it { expect { click_button "Create new user" }.not_to change(User, :count) }
		describe "After submission" do
			before { click_button "Create new user" }
			it { should have_selector('title', text:'Sign up')}
			it { should have_selector('div#error_explanation', text:'errors') }
		end
	end

	describe "User registration success" do
		before do
			visit signup_path
			fill_in "Name", with:"example.com"
			fill_in "Email", with:"example.com@example.com"
			fill_in "Password", with:"foobar"
			fill_in "Confirmation", with:"foobar"
		end
		it { expect { click_button "Create new user" }.to change(User,:count).by(1) }		
		describe "After submission" do
			before do 
				ActionMailer::Base.deliveries = []
				click_button "Create new user" 
			end
			it { should have_selector('div.alert.alert-success', text:'success')}
			it { should have_selector('div.alert.alert-notice', text:'email')}
			it { ActionMailer::Base.deliveries.last.to.should include("example.com@example.com")}
		end
	end

	describe "followers/following" do
		let(:user) { FactoryGirl.create(:user) }
		let(:followed_user) { FactoryGirl.create(:user) }
		let(:follower) { FactoryGirl.create(:user) }
		before do 
			signin_user(user)
			user.follow!(followed_user)
			follower.follow!(user)
		end
		describe "following" do
			before { visit following_user_path(user)}
			it { should have_selector('title', text:full_title("following"))}
			it { should have_selector('h3', text:"following") }
			it { should have_link(followed_user.name, href:user_path(followed_user))}
		end
		describe "followers" do
			before { visit followers_user_path(user)}
			it { should have_selector('title', text:full_title("followers"))}
			it { should have_selector('h3', text:"followers") }
			it { should have_link(follower.name, href:user_path(follower))}
		end
	end
end
