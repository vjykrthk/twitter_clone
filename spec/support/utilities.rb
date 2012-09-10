include ApplicationHelper

def signin_user(user)
	visit signin_path
	fill_in "Email", with:user.email
	fill_in "Password", with:user.password
	click_button "Sign in"
	cookies[:Rememberme_token] = user.rememberme_token
end