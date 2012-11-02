# coding = utf-8
class ActivitiesController < ApplicationController
  def new
  end

  def create
  	@activity = current_user.activities.build(params[:activity])
    @tag = Tag.find(params[:tag][:id])
    if @activity.save
      @activity.tag!(@tag)
      flash[:success] = "成功添加活动"
      redirect_to show_activity_path
    else
      @feed_items = []
      render 'static_pages/show_activity'
    end
  end

  def show
    @user = current_user
  	@activity = Activity.find(params[:id])
    @micropost  = @activity.microposts.build(user_id: @user.id, activity_id: @activity.id)
    @photo = @activity.photos.build
    @creator = @activity.creator
    @users = @activity.act_followers.paginate(page: params[:page])
    @microposts = @activity.microposts.paginate(page: params[:page])
  end

  def destroy
  	Activity.find(params[:id]).destroy
    @activity  = current_user.activities.build
    @activities = current_user.feed_for_activity.paginate(page: params[:page])
    flash[:success] = "成功删除活动！"
    redirect_to show_activity_path
  end

end
