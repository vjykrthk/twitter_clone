module SessionsHelper
	
	def signin_in(user)
		cookies.permanent[:Rememberme_token] = user.rememberme_token
		current_user = user
	end

	def signin_out
		cookies.delete(:Rememberme_token)
		current_user = nil
	end

	def signed_in?
		!current_user.nil?
	end

	def current_user=(user)
		@current_user = user
	end

	def current_user
		@current_user ||= User.find_by_rememberme_token(cookies[:Rememberme_token])
	end
end