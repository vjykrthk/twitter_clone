require 'spec_helper'

describe UsersController do 
	let(:user) { FactoryGirl.create(:user) }
	let(:m1) { FactoryGirl.create(:micropost, user:user)}
	let(:m2) { FactoryGirl.create(:micropost, user:user)}

	describe "RSS FEED" do
		before { signin_user(user) }
		it "Should return feed in atom format" do
			get :show, id: user, format:"atom"
			response.should be_success
			response.should render_template("users/show")
			response.content_type.should eq("application/atom+xml")
		end
	end

end