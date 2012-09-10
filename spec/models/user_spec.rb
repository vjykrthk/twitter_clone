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
end
