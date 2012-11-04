# coding = utf-8
class ActivitiesController < ApplicationController
  require 'net/http'
  require 'json'
  respond_to :html, :js, :json

  def new
  end

  def create
    # 由经纬度查询地址名称，和地址
    puts "-----------lat:" + params[:lat]
    puts "-----------lng:" + params[:lng]
    # @addressLine = getAddressLine(params[:lat], params[:lng])
    @addressSub = getAddress(params[:lat], params[:lng])
    puts "-----------before build activity  safsfa"
    puts "-----------current_user:" + current_user.name
    @activity = current_user.activities.build()
    puts "-----------user build activity"
    @tag = Tag.find_by_content(params[:type])
    @activity[:title] = params[:title]
    @activity[:time_start] = params[:startTime]
    @activity[:time_end] = params[:endTime]
    @activity[:pcount] = params[:peopleNum]
    @activity[:content] = params[:content]
    @activity[:back_up] = params[:ps]
    @activity[:GUID] = 0;
    @activity[:GUID_created_at] = 0;
    if @activity.save!
      puts "------------insert successful"
      @address = @activity.build_address()
      @address[:address] = @addressSub
      @address[:addressLine] = @addressLine
      @address[:lat] = params[:lat]
      @address[:lng] = params[:lng]
      if @address.save!
        puts "-----------adress saved successful, and activity created successful"
        #成功创建活动，下面开始广播这个新的活动
        publish_new_act(@activity)
      else
        puts "-----------address insert error"
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

  def index
    # @neighborActs = Activity.getNeighbor(paramms[:lat],params[:lng],0.01)
    puts "------lat:"+params[:lat]
    puts "------lng:"+params[:lng]
    @neighborActs = Activity.getNeighbor(params[:lat].to_f,params[:lng].to_f,0.01)
    puts "------getNeighbor success"
    puts "------测试current_user：" + current_user.name + "./" + current_user.email
    results = Hash.new
    results[:adjActs] = objs_to_hash(@neighborActs)
    results[:relaActs] = objs_to_hash(current_user.followed_acts)
    results[:ownActs] = objs_to_hash(current_user.activities)
    # puts results.to_json
    # respond_to do |format|
      respond_with results.to_json
    # end

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
    puts "------url:" + @url
    result = Net::HTTP.get(URI.parse(@url))
    puts "------success get results" + results
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
    puts "------url:" + @url
    result = Net::HTTP.get(URI.parse(@url))
    @json = JSON::parse(result)
    @address = @json["Placemark"][0]["address"]
    puts "------adress:" + @address
    return @address
  end

  def objs_to_hash(objs)
    acts = Array.new
    objs.each do |var|
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
      acts << act_hash
    end
    acts
  end

  #新建活动和之后，发布广播通知周围的已登录的用户和好友 
  def publish_new_act(act)
    puts "-------enter publish method"
    EM.run{
      puts "--------enter run block"
      client = Faye::Client.new('http://localhost:9292/faye')

      # client.subscribe('/activity/public') do |message|
      puts "--------acts => act new"
      # end
      #暂时替代数据
      @neighborActs = Activity.getNeighbor(25,102,1)
      puts "------getNeighbor success"
      results = Hash.new
      results[:adjActs] = objs_to_hash(@neighborActs)
      results[:relaActs] = objs_to_hash(@neighborActs)
      #重写部分

      # 首先被广播者应该是关注该活动创建人的用户，即活动创建者的好友
      @creator_followers = act.creator.followers
      puts "-------get followers  successful"
      # 之后是该活动位置周边登陆的用户
      @neighbor_singed_users = SignedAddress.get_near_by(act.address.lat, act.address.lng,10)
      puts "-------get neighbor_singed_users successful"

      # 开始publish
      @creator_followers.each do |user|
        puts "-------start publish to " + user.name + "channel"
        client.publish("/newact/#{user.name}", 'act' => act)
        puts "-------success publish to " + user.name + "channel"
      end

      @neighbor_singed_users.each do |user|
        puts "-------start publish to " + user.name + "channel"
        client.publish("/newact/#{user.name}", 'act' => act)
        puts "-------success publish to " + user.name + "channel"
      end
      puts "--------publish successful"
      # client.publish('/activity/public', 'acts' => results.to_json)
    }
  end


end
