class StaticPagesController < ApplicationController
  require 'net/http'
  require 'json'
  def home
    if signed_in?
      @micropost  = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page])
    end
  end
  
  def help
  end

  def about
    
  end

  def contact
  end

  def show_activity
    if signed_in?
      @tags = Tag.get_tags
      @activity  = current_user.activities.build
      # @feed_items = current_user.feed_for_activity.paginate(page: params[:page])
      @activities = current_user.feed_for_activity.paginate(page: params[:page])
    end
  end

  def map
    signed_in_user
    # @activity = current_user.activities.build
    # @activities = current_user.feed_for_activity.paginate(page: params[:page])
    @current_user = current_user
    @host_ip = local_ip
  end

  def login
    
  end
  
  def register
    @user = User.new
  end
  
  def setting
    @user = current_user
  end

  def jiepan
    # puts "get jiepan"
    puts params[:title]
  end
end
