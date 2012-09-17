require 'spec_helper'

describe RelationshipsController do

	let(:user) { FactoryGirl.create(:user) }
	let(:other_user) { FactoryGirl.create(:user) }
	before { signin_user(user) }
	
	describe "follow action in ajax" do

		it "should increment the number of followers of other_user" do
			expect do
				xhr :post, :create, relationship: { followed_id: other_user.id } 
			end.to change(Relationship, :count).by(1)
		end	

		it "should toggle follow button to unfollow" do			
			xhr :post, :create, relationship:{ followed_id: other_user.id } 
			response.should be_success		
		end
	end

	describe "unfollow action in ajax" do
		before { user.follow!(other_user) }
		let(:relationship) { user.relationships.find_by_followed_id(other_user)} 

		it "should increment the number of followers of other_user" do
			expect do
				xhr :delete, :destroy, id: relationship.id 
			end.to change(Relationship, :count).by(-1)
		end		

		it "should toggle follow button to unfollow" do			
			xhr :delete, :destroy, id: relationship.id 
			response.should be_success		
		end
	end
end