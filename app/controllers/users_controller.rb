class UsersController < ApplicationController

	before_filter :check_whether_the_user_is_signed_in, only: [ :index, :show, :edit, :update, :destroy, :following, :followers]
	before_filter :check_whether_correct_user, only: [:edit, :update]
	before_filter :check_whether_admin, only:[:destroy]

	def index
		@users = User.page(params[:page])
	end
  
	def show
		@user = User.find(params[:id])
		@microposts = @user.microposts.paginate(page: params[:page])		
	end

	def new
		@user = User.new
	end

	def create		
		@user = User.new(params[:user])
		
		if @user.save
			signin_in @user
			@user.send_email_confirmation
			flash[:success] = "You have successfully registered"
			flash[:notice] = "An email as send with instruction to complete registration"
			redirect_to root_path
		else
			render 'new'
		end
	end

	def edit
			
	end

	def update
		@user = User.find(params[:id])
		if @user.update_attributes(params[:user])
			signin_in @user
			flash[:success] = "You profile has been successfully updated"
			redirect_to @user
		else
			render 'edit'
		end
		
	end

	def destroy
		User.find(params[:id]).destroy
		flash[:success] = "User destroyed"
		redirect_to users_path
	end

	def following
		@title = "following"
		@user = User.find(params[:id])
		@users = @user.followed_users.paginate(page: params[:page])
		render 'show_follow'
	end

	def followers
		@title = "followers"
		@user = User.find(params[:id])
		@users = @user.followers.paginate(page: params[:page])
		render 'show_follow'
	end

	def confirm
		@user = User.find_by_confirmation_code(params[:confirm_id])
		if @user && @user.confirmation_code_send_at > 2.hours.ago
			@user.toggle!(:email_confirmed)
			@user.confirmation_code = nil
			@user.confirmation_code_send_at = nil
			@user.save!(:validate => false)
			signin_in @user
			flash[:success] = "Your registration is complete"
			redirect_to @user
		else
			redirect_to root_path
		end
	end

	def check_whether_correct_user
		@user = User.find_by_id(params[:id])
		redirect_to root_path unless @user == current_user
	end

	def check_whether_admin
		redirect_to root_path unless current_user.admin?
	end
end
