class UserAcRelasController < ApplicationController
	before_filter :signed_in_user

  	# respond_to :html, :js

	def create
		@user = current_user
		@activity = Activity.find(params[:user_ac_rela][:activity_id])
		current_user.follow_for_activity!(@activity)
		@creator = @activity.creator
		@users = @activity.act_followers.paginate(page: params[:page])
		respond_to do |format|
			format.html {redirect_to activities_path+"/#{activity.id}"}
			format.js
		end
	end

	def destroy
		@user = current_user
		@activity = UserAcRela.find(params[:id]).activity
		current_user.unfollow_for_activity!(@activity)
		@creator = @activity.creator
		@users = @activity.act_followers.paginate(page: params[:page])
		respond_to do |format|
			format.html {redirect_to activities_path+"/#{activity.id}"}
			format.js
		end
	end
end