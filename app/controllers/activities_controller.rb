# coding = utf-8
class ActivitiesController < ApplicationController
  require 'net/http'
  require 'json'
  def new
  end

  def create
    @addressLine = getAddressLine(params[:lat], params[:lng])
    @addressSub = getAddress(params[:lat], params[:lng])
    @activity = current_user.activities.build()
    @tag = Tag.find_by_content(params[:type])
    @activity[:title] = params[:title]
    @activity[:time_start] = params[:startTime]
    @activity[:time_end] = params[:endTime]
    @activity[:pcount] = params[:peopleNum]
    @activity[:content] = params[:content]
    @activity[:back_up] = params[:ps]
    # @address[:lat] = params[:lat]
    # @address[:lng] = params[:lng]
    @activity[:GUID] = 0;
    @activity[:GUID_created_at] = 0;
    if @activity.save
      puts "------------insert successful"
      @address = @activity.build_address()
      @address[:address] = @addressSub
      @address[:addressLine] = @addressLine
      @address[:lat] = params[:lat]
      @address[:lng] = params[:lng]
      if @address.save
        puts "-----------adress saved successful"
      end
    else
      puts "------------insert error"
    end

  	# @activity = current_user.activities.build(params[:activity])
   #  @tag = Tag.find(params[:tag][:id])
   #  if @activity.save
   #    @activity.tag!(@tag)
   #    flash[:success] = "成功添加活动"
   #    redirect_to show_activity_path
   #  else
   #    @feed_items = []
   #    render 'static_pages/show_activity'
   #  end
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

  def getAddressLine(lat, lng)
    puts "--Enter getAddressLine method"
    @url = "http://ditu.google.cn/maps/geo?output=json&key=abcdef&q=#{lat},#{lng}"
    puts "url:" + @url
    result = Net::HTTP.get(URI.parse(@url))
    @addressLine = "该地址没有确切的地名"
    @json = JSON::parse(result)
    if @json["Placemark"][0]["AddressDetails"]["Country"]["AdministrativeArea"]["Locality"]["DependentLocality"].has_key?"AddressLine"
      @addressLine =  @json["Placemark"][0]["AddressDetails"]["Country"]["AdministrativeArea"]["Locality"]["DependentLocality"]["AddressLine"][0]
    end
    return @addressLine
  end

  def getAddress(lat, lng)
    puts "--Enter getAddress method"
    @url = "http://ditu.google.cn/maps/geo?output=json&key=abcdef&q=#{lat},#{lng}"
    puts "url:" + @url
    result = Net::HTTP.get(URI.parse(@url))
    @json = JSON::parse(result)
    @address = @json["Placemark"][0]["address"]
    return @address
  end

end
