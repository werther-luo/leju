# coding = utf-8
class PhotosController < ApplicationController
  def new
  end

  def destroy
  end

  def create
  	@photo = Photo.create(params[:photo])
  	@activity_id = params[:activity_id]
  	@photo.user_id = current_user.id
  	@photo.activity_id = @activity_id
    if @photo.save
      	flash[:success] = "成功上传图片！"
	   	@user = current_user
	  	@activity = Activity.find(@activity_id)
	    @micropost  = @activity.microposts.build(user_id: @user.id, activity_id: @activity.id)
	    @photo = @activity.photos.build(user_id: @user_id)
	    @creator = @activity.creator
	    @users = @activity.act_followers.paginate(page: params[:page])
	    @microposts = @activity.microposts.paginate(page: params[:page])
	  	redirect_to activities_path+"/#{@activity_id}"
    else
      	flash[:failure] = "图片上传失败！"
	   	@user = current_user
	  	@activity = Activity.find(@activity_id)
	    @micropost  = @activity.microposts.build(user_id: @user.id, activity_id: @activity.id)
	    @photo = @activity.photos.build(user_id: @user_id)
	    @creator = @activity.creator
	    @users = @activity.act_followers.paginate(page: params[:page])
	    @microposts = @activity.microposts.paginate(page: params[:page])
	  	redirect_to activities_path+"/#{@activity_id}"
    end

  end
end
