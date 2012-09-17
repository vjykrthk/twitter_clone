require 'spec_helper'

describe "AuthenticationPages" do
	subject { page }
	describe "Signin path" do
		before { visit signin_path }
		it { should have_selector('h1', text:'Sign in')}
		it { should have_selector('title', text:'Sign in')}
	end

	describe "Signing in" do
		before { visit signin_path }
		describe "Invalid signing in" do
			before { click_button "Sign in" }			
			it { should have_selector('h1', text:'Sign in')}
			it { should have_selector('title', text:'Sign in')}
			it { should have_selector('div.alert.alert-errors', text:'Invalid')}
			describe "Should not have flash message when click on the link" do
				before { click_link "Home" }
				it { should_not have_selector('div.alert.alert-errors') }
				it { should_not have_link "Profile"}
				it { should_not have_link "Signout",  href:signout_path}
			end
		end

		describe "Valid signing in" do
			let(:user) { FactoryGirl.create(:user) }
			before do
				fill_in "Email",  	with:user.email
				fill_in "Password", with:user.password
				click_button "Sign in"
			end
			it { should have_selector "h1",  text:user.name}
			it { should have_link "Settings", href:edit_user_path(user) }
			it { should have_link "Users", href:users_path}
			it { should have_link "Profile", href:user_path(user)}
			it { should have_link "Signout",  href:signout_path}
		end

		describe "Authorization" do
			let(:user) { FactoryGirl.create(:user) }
			describe "Unauthorized access" do
				describe "Non signed user" do
					describe "Should not be able access profile page without signing in" do
						before { visit edit_user_path(user) }
					end

					describe "Should not be able update without sign in" do
						before { put user_path(user) }
						specify { response.should redirect_to(signin_path)}
					end

					describe "Should not be able to access users index page" do
						before { visit users_path }
						it { should have_selector('h1', text:'Sign in')}				
						it { should have_selector('div.alert.alert-notice', text:'Please signin') }
					end

					describe "in Micropost controller" do						
						describe "Submitting to the create action" do
							before { post microposts_path }
							it { response.should redirect_to(signin_path)}
						end
						describe "Delete a micropost" do
							before { delete micropost_path(FactoryGirl.create(:micropost)) }
							it { response.should redirect_to(signin_path)}
						end
					end
					describe "following page" do
						before { visit following_user_path(user)}
						it { should have_selector('h1', text:'Sign in')}
					end
					describe "followers page" do
						before { visit followers_user_path(user) }
						it { should have_selector('h1', text:'Sign in')}
					end
				
					describe "Relationship" do
						it "post action" do
							post relationships_path
							response.should redirect_to(signin_path)
						end
						it "post action" do
							delete relationship_path(1)
							response.should redirect_to(signin_path)
						end
					end
				end
				describe "Signed user" do
					let(:user) { FactoryGirl.create(:user) }
					let(:wrong_user) { FactoryGirl.create(:user, email:"wrong@email.com") }	
					before { signin_user(user) }				
					describe "Correct user should be able to edit the profile" do
						before { visit edit_user_path(wrong_user) }
						it { should have_selector('title', text:'Home') }
					end
					describe "Correct user should be able to update the profile" do
						before { put user_path(wrong_user) }
						specify { response.should redirect_to root_path }
					end

					describe "Should not be able delete a user" do
						before { delete user_path(user) }
						specify { response.should redirect_to root_path }
					end
				end

				describe "Afer signing in" do
					let(:user) { FactoryGirl.create(:user) }
					it "Should redirected to the right page" do
						visit edit_user_path(user)
						fill_in "Email", with:user.email
						fill_in "Password", with:user.password
						click_button "Sign in"
						should have_selector('h1', text:"Edit user")
					end
				end
			end


							
		end		
	end	
end
