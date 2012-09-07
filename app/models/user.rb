class User < ActiveRecord::Base
	before_save { |user| user.email = user.email.downcase }
	before_save :create_a_rememberme_token
	
	has_secure_password

	attr_accessible :email, :name, :password, :password_confirmation
	validates :name, 	presence:true, length:{ maximum:50 }
	VALID_EMAIL_REGEX = /\A[\w\-.+]+@[a-z\d.]+\.[a-z]+\z/i
	validates :email, 	presence:true, 
						format:VALID_EMAIL_REGEX, 
						uniqueness:{ case_sensitive:false }
	validates :password, length:{ minimum:6 }
	validates :password_confirmation, presence:true

	private

	def create_a_rememberme_token				
		self.rememberme_token = SecureRandom.urlsafe_base64
	end
end
