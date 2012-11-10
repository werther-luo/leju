# coding = utf-8
class StaticPagesController < ApplicationController
  require 'net/http'
  require 'json'
	before_filter :signed_in_user,:except => [:login,:register]
	respond_to :html, :js, :json
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
  
  def show_all
    @user = current_user
    @joined_acts = @user.followed_acts.limit(10)
    @owned_acts = @user.activities.limit(10)
    # 开始取用户评论，首先取用户创建的活动的有关评论
    @own_acts_comments = Array.new
    @user.activities.each do |act|
      act.microposts.each do |micropost|
        micro_hash = Hash.new
        micro_hash[:id] = micropost.id
        micro_hash[:user] = micropost.user
        micro_hash[:act_title] = act.title
        micro_hash[:content] = micropost.content
        micro_hash[:created_date] = micropost.created_at
        micro_hash[:type] = "“#{micropost.user.name}”对你创建的活动“#{act.title}”说："
        @own_acts_comments << micro_hash
      end
    end
    
    #然后取用户参加活动的评论
    @joined_acts_comments = Array.new
    @user.followed_acts.each do |act|
      act.microposts.each do |micropost|
        micro_hash = Hash.new
        micro_hash[:id] = micropost.id
        micro_hash[:user] = micropost.user
        micro_hash[:act_title] = act.title
        micro_hash[:content] = micropost.content
        micro_hash[:created_date] = micropost.created_at.to_s(:due_time)
        micro_hash[:type] = "“#{micropost.user.name}”对你参加的活动“#{act.title}”说："
        @joined_acts_comments << micro_hash
      end
    end
    
    #然后去用户关注的好友的评论
    @followed_user_comments = Array.new
    @user.followed_users.each do |followed_user|
      followed_user.microposts.each do |micropost|
        micro_hash = Hash.new
        micro_hash[:id] = micropost.id
        micro_hash[:user] = micropost.user
        if micropost.activity_id
          micro_hash[:act_title] = Activity.find(micropost.activity_id).title
        end
        micro_hash[:content] = micropost.content
        micro_hash[:created_date] = micropost.created_at.to_s(:due_time)
        micro_hash[:type] = "你的好友“#{followed_user.name}”说："
        micro_hash[:user_photo] = micropost.user.photo.url(:thumb)
        @followed_user_comments << micro_hash
      end
    end
    #最后将所有的评论按时间先后进行排序
    @all_comments = @own_acts_comments + @joined_acts_comments + @followed_user_comments
    @all_comments.sort_by{|c| c[:created_date]} 
    # @all_comments.reverse!
    
    
  end
  
  def show_act
    @activity = Activity.find(params[:id])
    @acts_comments = Array.new
    @user = current_user
    #get  activity microposts
    @activity.microposts.each do |micropost|
      micro_hash = Hash.new
      micro_hash[:id] = micropost.id
      micro_hash[:user] = micropost.user
      micro_hash[:act_title] = @activity.title
      micro_hash[:content] = micropost.content
      micro_hash[:created_date] = micropost.created_at.to_s(:due_time)
      micro_hash[:type] = "“#{current_user.name}”对你参加的活动“#{@activity.title}”说："
      @acts_comments << micro_hash
    end
    
    @acts_comments.sort_by{|c| c[:created_date]} 
    # @acts_comments.reverse!
  end
  
  def comment
    @micropost = current_user.microposts.build
    activity_id = params[:id].to_i
    if params[:id]
      @micropost.activity_id = params[:id]
      puts @micropost.activity_id
    end
  end
  
  def picture_new
    activity_id = params[:id].to_i
  	@activity = Activity.find(params[:id])
    @photo = @activity.photos.build
  end
  
  def act_photo
    @user = current_user
  	@activity = Activity.find(params[:id])
    @creator = @activity.creator
  end

  def jiepan
    # puts "get jiepan"
    puts params[:title]
  end
  
  def get_all_comments
    @user = current_user
    @joined_acts = @user.followed_acts.limit(10)
    @owned_acts = @user.activities.limit(10)
    # 开始取用户评论，首先取用户创建的活动的有关评论
    @own_acts_comments = Array.new
    @user.activities.each do |act|
      act.microposts.each do |micropost|
        micro_hash = Hash.new
        micro_hash[:id] = micropost.id
        micro_hash[:user] = micropost.user.name
        micro_hash[:act_title] = act.title
        micro_hash[:content] = micropost.content
        micro_hash[:created_date] = micropost.created_at
        micro_hash[:type] = "对你创建的活动"
        @own_acts_comments << micro_hash
      end
    end
    
    #然后取用户参加活动的评论
    @joined_acts_comments = Array.new
    @user.followed_acts.each do |act|
      act.microposts.each do |micropost|
        micro_hash = Hash.new
        micro_hash[:id] = micropost.id
        micro_hash[:user] = micropost.user.name
        micro_hash[:act_title] = act.title
        micro_hash[:content] = micropost.content
        micro_hash[:created_date] = micropost.created_at
        micro_hash[:type] = "对你参加的活动"
        @joined_acts_comments << micro_hash
      end
    end
    
    #然后去用户关注的好友的评论
    @followed_user_comments = Array.new
    @user.followed_users.each do |followed_user|
      followed_user.microposts.each do |micropost|
        micro_hash = Hash.new
        micro_hash[:id] = micropost.id
        micro_hash[:user] = micropost.user.name
        if micropost.activity_id
          micro_hash[:act_title] = Activity.find(micropost.activity_id).title
        end
        micro_hash[:content] = micropost.content
        micro_hash[:created_date] = micropost.created_at
        micro_hash[:type] = "你的好友说"
        @followed_user_comments << micro_hash
      end
    end
    #最后将所有的评论按时间先后进行排序
    @all_comments = @own_acts_comments + @joined_acts_comments + @followed_user_comments
    @all_comments.sort_by{|c| c[:created_date]}
    
    respond_to do |format|
      format.json { render :json => @all_comments }
    end
  end
end
