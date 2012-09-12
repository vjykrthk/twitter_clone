class StaticPagesController < ApplicationController
  
  def home
  	if signed_in?
  		@micropost = current_user.microposts.build 
      #@feeds = current_user.feed     
  		@feeds = current_user.feed.paginate(page: params[:page])    
  	end
  end
  
  def about
  end

  def help
  end

  def contact
  end
end
