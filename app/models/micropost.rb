class Micropost < ActiveRecord::Base
	belongs_to :user
	attr_accessible :content
	validates :content, presence:true, length: { maximum:140}
	validates :user_id, presence:true
	default_scope order:'microposts.created_at DESC'

	def self.from_users_followed_by(user)
		followed_users = "SELECT followed_id FROM relationships WHERE follower_id = :user_id"
		where("user_id IN (#{followed_users}) OR user_id = :user_id", user_id:user.id )
	end
end