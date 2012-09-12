require 'spec_helper'
	
describe "MicropostPages" do
	let(:user) { FactoryGirl.create(:user)}
	before do 
		signin_user(user)
		visit root_path 
	end
	describe "Post with invalid information" do		
		it "Should not number of micropost" do
			expect do
				click_button 'Post'
			end.not_to change(Micropost, :count)
		end
		it "Should show error message" do 
			click_button 'Post'
			page.should have_content "error"
		end
	end

	describe "Post with valid information" do
		before { fill_in "micropost_content", with:"Lorem ipsum" }
		it "Should not number of micropost" do
			expect do
				click_button 'Post'
			end.to change(Micropost, :count).by(1)
		end
	end

	describe "Delete" do
		before do
			FactoryGirl.create(:micropost, user:user)
			visit root_path
		end
		it "Should change the number of post" do
			expect do
				click_link "delete"
			end.to change(Micropost, :count).by(-1)
		end
	end
end
