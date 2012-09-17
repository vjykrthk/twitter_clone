require 'spec_helper'

describe User do
	subject { @user }
	before { @user = User.new(	name:"moyo", 
								email:"moyo@example.com", 
								password:"hohoho", 
								password_confirmation:"hohoho") }
 	
 	describe "user should respond to the following methods" do 		
 		it { should respond_to(:name) }
 		it { should respond_to(:email) }
 		it { should respond_to(:password_digest )}
 		it { should respond_to(:password) }
 		it { should respond_to(:rememberme_token)}
 		it { should respond_to(:password_confirmation) }
 		it { should respond_to(:authenticate) }
 		it { should respond_to(:admin) }
 		it { should respond_to(:relationships)}
 		it { should respond_to(:followed_users) }
 		it { should respond_to(:followers) }
 		it { should respond_to(:follow!) }
 		it { should respond_to(:following?) }
 	end

 	describe "With admin attributes set to true" do
 		before do
 			@user.save
 			@user.toggle!(:admin)
 		end
 		
 		it { should be_admin }
 	end

 	describe "Creation of new user should check for presence of name" do
 		before { @user.name = ""}
 		it { should_not be_valid }
 	end
 	
 	describe "Creation of new user should check for presence of email" do
 		before { @user.email = ""}
 		it { should_not be_valid }
 	end
 	
 	describe "user name should not be more than 50 characters" do
 		before { @user.name = "a" * 51 }
 		it { should_not be_valid }
 	end

 	describe "Check valid and invalid email" do
 		it "Should check valid email" do
 			valid_email = %w[	
 								user-user@example.com 
 								user@exampLe.COM.in
 								user+user@example.com 
 							]
 			valid_email.each do |email|
 				@user.email = email
 				@user.should be_valid 				
 			end				
 		end

 		it "Should check invalid email" do
 			invalid_email = %w[	
 								user-user@example,com 
 								user+user@example. 
 								user.example.com
 								user@exmaple-
 							]
 			invalid_email.each do |email|
 				@user.email = email
 				@user.should_not be_valid 				
 			end				
 		end
	end

	describe "Should check for the uniqueness of the email" do
		before do
			@user.save
			@same_email = @user.dup
			@same_email.save
		end
		it { @same_email.should_not be_valid }			
	end

	describe "Email uniqueness should be case insensitive" do
		before do
			@user.save
			@upcased_same_email = @user.dup
			@upcased_same_email.email = @upcased_same_email.email.upcase
			@upcased_same_email.save
			@user.save
		end
		it { @upcased_same_email.should_not be_valid }		
	end
	describe "Password fields cannot be blank" do
		before do
			@user.password = @user.password_confirmation = ""
			@user.save
		end
		it { @user.should_not be_valid }
	end
	describe "Passwords and Password confirmation should match" do
		before do
			@user.password_confirmation = "mismatch"
		end
		it { @user.should_not be_valid }
	end
	describe "Password confirmation should not be nil" do
		before do
			@user.password_confirmation = nil
		end
		it { @user.should_not be_valid }
	end

	describe "return value of authenticate method" do
		before { @user.save }
		let(:found_user) { User.find_by_email(@user.email)}
		describe "for valid user" do
			it { should == found_user.authenticate(@user.password) }
		end
		describe "for invalid user" do
			let(:invalid_user) { found_user.authenticate("invalid") }
			it { should_not == invalid_user }
			specify { invalid_user.should be_false}
		end	
	end
	describe "Password should be more than 6 characters" do
		before { @user.password = @user.password_confirmation = "a" * 5 }
		it { should_not be_valid }
	end
	describe "Micropost association" do
		before { @user.save }
		let!(:m1) { FactoryGirl.create(:micropost, user:@user, created_at:1.day.ago) }
		let!(:m2) { FactoryGirl.create(:micropost, user:@user, created_at:1.hour.ago) }

		describe "It should return micropost in right order" do
			it { @user.microposts.should == [m2, m1] }
		end 

		it "When user is delete it should destroy all associated microposts" do
			microposts = @user.microposts
			@user.destroy
			microposts.each do |micropost|
				Micropost.find_by_id(micropost.id).should be_nil
			end
		end

		describe "Status" do
			let(:unfollowed_user) { FactoryGirl.create(:user, email:"donot@gmail.com") }
			let!(:unfollowed_post) do
				FactoryGirl.create(:micropost,user:unfollowed_user)
			end
			let(:followed_user) { FactoryGirl.create(:user) }
			before do
				@user.follow!(followed_user)
				3.times do
					FactoryGirl.create(:micropost,user:followed_user)
				end
			end

			its(:feed) { should include(m1)}
			its(:feed) { should include(m2)}
			its(:feed) { should_not include(unfollowed_post)}				
			its(:feed) do
				followed_user.microposts.each do |micropost| 
					should include(micropost)
				end
			end
			
		end
	end

	describe "following" do
		let(:other_user) { FactoryGirl.create(:user) }
		before do
			@user.save
			@user.follow!(other_user)
		end

		it { should be_following(other_user) }
		its(:followed_users) { should include(other_user) }

		describe "unfollow" do
			before { @user.unfollow(other_user) }
			its(:followed_users) { should_not include(other_user) }
		end

		describe "following" do
			subject { other_user }
			its(:followers) { should include(@user) }
		end
	end


	
end
