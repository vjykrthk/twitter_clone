require 'spec_helper'

describe Micropost do 
	subject { @micropost}
	let(:user) { FactoryGirl.create(:user) }
	before do
		@micropost = user.microposts.build(content:"Lorem ipsum Lorem ipsum")
	end

	describe "micropost should respond to following methods" do
		it { should respond_to(:content) }
		it { should respond_to(:user_id) }
		it { should be_valid }
		it { should respond_to(:user) }
		its(:user) { should == user }
	end
	describe "Mass assigning user_id should raise an exception" do
		it "should raise a exception" do
			expect do
				Micropost.new(content:"Lorem ipsum", user_id:user.id) 
			end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
		end
	end

	describe "when content is not present" do
		before { @micropost.content = ""}
		it { should_not be_valid }
	end

	describe "when content is not present" do	
		before { @micropost.content = "a" * 141}
		it { should_not be_valid }
	end

	describe "when user id is not present" do
		before { @micropost.user_id = nil}
		it { should_not be_valid }
	end
end