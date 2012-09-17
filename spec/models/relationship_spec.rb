require 'spec_helper'

describe Relationship do

	subject{ @relationships }	

	let(:follower) { FactoryGirl.create(:user)}
	let(:followed) { FactoryGirl.create(:user)}
	before { @relationships = follower.relationships.build(followed_id:followed.id) }

	it { should be_valid }

	it "Should raise an exception assignment of follwer id" do
		expect do
			Relationship.new(follower_id:follower)
		end.to raise_error(ActiveModel::MassAssignmentSecurity::Error) 
	end

	describe "follower method" do
		it { should respond_to(:follower)}
		it { should respond_to(:followed)}

		its(:follower) { should == follower}
		its(:followed) { should == followed}
	end

	describe "When followed id is not present" do
		before { @relationships.followed_id = nil }
		it { should_not be_valid}
	end

	describe "When followed id is not present" do
		before { @relationships.follower_id = nil }
		it { should_not be_valid}
	end

end
