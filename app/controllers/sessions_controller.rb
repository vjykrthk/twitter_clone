class SessionsController < ApplicationController
	
	def new
	end
	
	def create
		user = User.find_by_email(params[:sessions][:email])
		if user && user.authenticate(params[:sessions][:password])
			signin_in(user)
			redirect_to user_path(user)
		else
			flash.now[:errors] = "Invalid user/password"
			render 'new'
		end
	end

	def destroy
		signin_out
		redirect_to root_url
	end
end
