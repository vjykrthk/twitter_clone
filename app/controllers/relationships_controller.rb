class RelationshipsController < ApplicationController
	before_filter :check_whether_the_user_is_signed_in

	def create
		@user = User.find(params[:relationship][:followed_id])
		current_user.follow!(@user)
		respond_to do |format|
			format.html { redirect_to @user }
			format.js 
		end			
	end

	def destroy
		@user = User.find(Relationship.find(params[:id]).followed_id)
		Relationship.find(params[:id]).delete
		respond_to do |format|
			format.html { redirect_to @user  }
			format.js
		end		
	end

end