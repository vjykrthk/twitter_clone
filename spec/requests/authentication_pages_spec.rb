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
			it { should have_link "Profile", href:user_path(user)}
			it { should have_link "Signout",  href:signout_path}
		end


		
	end	
end
