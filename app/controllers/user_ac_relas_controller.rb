# coding = utf-8
class UserAcRelasController < ApplicationController
  require 'net/http'
  require "json"
	before_filter :signed_in_user
	respond_to :html, :js, :json

  	# respond_to :html, :js

	def create
		# @user = current_user
		# @activity = Activity.find(params[:user_ac_rela][:activity_id])
		# current_user.follow_for_activity!(@activity)
		# @creator = @activity.creator
		# @users = @activity.act_followers.paginate(page: params[:page])
		# respond_to do |format|
		# 	format.html {redirect_to activities_path+"/#{@activity.id}"}
		# 	format.js
		# end
		puts "-------enter user_ac_relas create method"
		@user = current_user
		puts "-------geted activity_id:" + params[:activity_id]
		@act = Activity.find(params[:activity_id])
		puts "-------finded id:" + @act.id.to_s
		@user.follow_for_activity!(@act)
		puts "-------success join activity"
		puts "-------joined activity:" + @act.id.to_s

    #respond_with obj_to_hash(@act).to_json
    respond_to do |format|
      format.json { render :json => obj_to_hash(@act) }
    end
	end

	def destroy
		# @user = current_user
		# @activity = UserAcRela.find(params[:id]).activity
		# current_user.unfollow_for_activity!(@activity)
		# @creator = @activity.creator
		# @users = @activity.act_followers.paginate(page: params[:page])
		# respond_to do |format|
		# 	format.html {redirect_to activities_path+"/#{@activity.id}"}
		# 	format.js
		# end
		@user = current_user
		@activity = Activity.find(params[:activity_id])
		@user.unfollow_for_activity!(@activity)
		@creator = @activity.creator
		respond_with obj_to_hash(@activity).to_json
	end

	def obj_to_hash(var)
	  act_hash = Hash.new
	  act_hash[:id] = var.id
	  act_hash[:title] = var.title
	  act_hash[:time_start] = var.time_start
	  act_hash[:time_end] = var.time_end
	  act_hash[:content] = var.content 
	  act_hash[:address] = var.address.address 
	  act_hash[:address_line] = var.address.addressLine
	  act_hash[:ps] = var.back_up 
	  act_hash[:state] = var.state 
	  act_hash[:created_at] = var.created_at 
	  act_hash[:creator_id] = var.user_id
	  act_hash[:creator_name] = User.find(var.user_id).name
	  act_hash[:creator_photo] = User.find(var.user_id).photo.url(:thumb)
	  act_hash[:lat] = var.address.lat
	  act_hash[:lng] = var.address.lng
    act_hash[:type] = var.tags[0].content
	  act_hash
	end
end