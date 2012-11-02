#coding = utf-8
class MicropostsController < ApplicationController
  before_filter :signed_in_user
  before_filter :correct_user,   only: :destroy

  def create
    @micropost = current_user.microposts.build(params[:micropost])
    @activity_id = params[:activity_id]
    # puts "--------------------------------------------"
    # puts @activity_id
    # puts "--------------------------------------------"
    if @activity_id
      @micropost.activity_id = @activity_id.to_i
      if @micropost.save
        @user = current_user
        @activity = Activity.find(@activity_id)
        @microposts = @activity.microposts.paginate(page: params[:page])
        @micropost  = @activity.microposts.build(user_id: @user.id)
        @creator = @activity.creator
        flash[:success] = "成功发布评论！"
        redirect_to activities_path+"/#{@activity_id}"
      else
        @feed_items = []
        render 'static_pages/home'
      end
    else
      if @micropost.save
        flash[:success] = "成功发布说说！"
        redirect_to root_path
      else
        @feed_items = []
        render 'static_pages/home'
      end
    end

    
  end

  def destroy
    @micropost.destroy
    redirect_to root_path
  end

  private

    def correct_user
      @micropost = current_user.microposts.find_by_id(params[:id])
      redirect_to root_path if @micropost.nil?
    end
end