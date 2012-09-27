class User < ActiveRecord::Base
	has_many :microposts, dependent: :destroy
	has_many :relationships, foreign_key:"follower_id", dependent: :destroy
	has_many :followed_users, through: :relationships, source:"followed"

	has_many :reverse_relationships, class_name:Relationship, foreign_key:"followed_id", dependent: :destroy
	has_many :followers, through: :reverse_relationships, source:"follower"


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


	
	def feed
		Micropost.from_users_followed_by(self)
	end

	def follow!(user)
		relationships.create!(followed_id:user.id)
	end

	def unfollow(user)
		relationships.find_by_followed_id(user.id).destroy
	end

	def following?(user)
		relationships.find_by_followed_id(user.id)
	end

	def send_email_confirmation
		generate_token(:confirmation_code)
		self.confirmation_code_send_at = Time.zone.now
		self.email_confirmed = false
		save!(:validate => false)
		UserMailer.email_confirmation(self).deliver
	end

	def generate_token(column)
		begin
			self[column] = SecureRandom.urlsafe_base64
		end while User.exists?(column => self[column])
	end
	
	private

	def create_a_rememberme_token				
		self.rememberme_token = SecureRandom.urlsafe_base64
	end
end
