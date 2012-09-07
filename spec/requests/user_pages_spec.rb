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
		before { visit user_path(user) }
		it { should have_selector('title', text:user.name) }
		it { should have_selector('h1', text:user.name) }
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
			before { click_button "Create new user" }
			it { should have_selector('div.alert.alert-success', text:'success')}
		end
	end

end
