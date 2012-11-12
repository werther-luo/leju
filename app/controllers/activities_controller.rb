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
    @addressLine = getAddressLine(params[:lat], params[:lng])
    @addressSub = getAddress(params[:lat], params[:lng])
    puts "-----------before build activity  safsfa"
    # puts "-----------current_user:" + current_user.name
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
        if @activity.tag!(@tag)
          puts "-----------teaged!"
        end
        #成功创建活动，下面开始广播这个新的活动
        publish_new_act(@activity)
      else
        puts "-----------address insert error"
      end
    else
      puts "------------insert error"
    end

    # return_val = "success"
    # respond_with return_val.to_json

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
    @neighborActs = Activity.getNeighbor(params[:lat].to_f,params[:lng].to_f,1)
    # puts @neighborActs
    # puts "---------------------------------------"
    # 周围的活动不包括该用户已经参加的
    @neighborActs = @neighborActs - current_user.followed_acts
    # puts @neighborActs
    # 周围的活动也不包括用户自己创建的
    @neighborActs = @neighborActs - current_user.activities
    # puts "---------------------------------------"
    puts @neighborActs
    puts "------getNeighbor success"
    #puts "------测试current_user：" + current_user.name + "./" + current_user.email
    results = Hash.new
    results[:adjActs] = objs_to_hash(@neighborActs)
    # puts "------what the fuck,fuckfuckfuckfuckfuckfuckfuckfuckfuckfuck"
    results[:relaActs] = objs_to_hash(current_user.followed_acts)
    # puts "------what the fuck,fuckfuckfuckfuckfuckfuckfuckfuckfuckfuck"
    results[:ownActs] = objs_to_hash(current_user.activities)
    # puts "------what the fuck,fuckfuckfuckfuckfuckfuckfuckfuckfuckfuck"

    # puts results.to_json
    # respond_to do |format|

    puts results.to_json
    respond_with results.to_json
    # end

  end
  
  #搜索该用户周围的活动，返回其标题或内容与所给关键字相同的活动列表。json
  def serach_by_title_or_content
    @key = params[:key]
    #得到周围的活动列表
    puts params[:lat]
    puts params[:lng]
    @lat = 25.037721 #params[:lat]
    @lng = 102.722202 #params[:lng]
    @neighborActs = Activity.getNeighbor(@lat.to_f,@lng.to_f,1)
    puts @neighborActs.to_json
    @neighborActs = @neighborActs - current_user.followed_acts #除去自己已经参加的活动
    @neighborActs = @neighborActs - current_user.activities    #除去自己创建的活动
    puts "----------search results:"
    puts @neighborActs.to_json
    @del_acts = Array.new
    @neighborActs.each do |act|
      if !(act.title.include?(@key) or act.content.include?(@key))
        @del_acts << act
      end
    end
    @neighborActs = @neighborActs - @del_acts
    
    respond_with @neighborActs.to_json
    
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

  #GoogleMapAPI得到地名，传入经纬度参数
  def getAddressLine(lat, lng)
    puts "--Enter getAddressLine method"
    @url = "http://ditu.google.cn/maps/geo?output=json&key=abcdef&q=#{lat},#{lng}"
    puts "------url:" + @url
    result = Net::HTTP.get(URI.parse(@url))
    puts "------success get results"
    @addressLine = getAddress(params[:lat], params[:lng])
    @json = JSON::parse(result)
    if @json["Placemark"][0]["AddressDetails"]["Country"]["AdministrativeArea"]["Locality"]["DependentLocality"].has_key?"AddressLine"
      @addressLine =  @json["Placemark"][0]["AddressDetails"]["Country"]["AdministrativeArea"]["Locality"]["DependentLocality"]["AddressLine"][0]
    end
    return @addressLine
  end

  #根据传过来的参数使用GoogleMapApi请求地址
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

  #把活动数组转换成哈希表
  def objs_to_hash(objs)
    puts "------what the fuck,fuckfuckfuckfuckfuckfuckfuckfuckfuckfuck"
    # puts "--------enter objs_to_hash method"
    acts = Array.new
    objs.each do |var|
      act_hash = Hash.new
      act_hash[:id] = var.id
      act_hash[:title] = var.title
      act_hash[:time_start] = var.time_start.to_s(:due_time)
      puts "----------ppppppppppppppppppppppppppppppppppppppppppppp"
      act_hash[:time_end] = var.time_end.to_s(:due_time)
      act_hash[:content] = var.content 
      act_hash[:address] = var.address.address 
      act_hash[:address_line] = var.address.addressLine
      act_hash[:ps] = var.back_up 
      act_hash[:state] = var.state 
      act_hash[:created_at] = var.created_at.to_s(:due_time)
      act_hash[:creator_id] = var.user_id
      act_hash[:creator_name] = User.find(var.user_id).name
      act_hash[:creator_photo] = User.find(var.user_id).photo.url(:thumb)
      act_hash[:lat] = var.address.lat
      act_hash[:lng] = var.address.lng
      act_hash[:type] = var.tags[0].content
      acts << act_hash
    end
    puts "-----------end of the moethod"
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
        puts "-------json:" + obj_to_hash(act).to_json
        client.publish("/newact/#{user.id}", 'act' => obj_to_hash(act).to_json)
        puts "-------success publish to " + user.name + "channel"
      end

      @neighbor_singed_users.each do |user|
        puts "-------start publish to " + user.name + "channel"
        client.publish("/newact/#{user.id}", 'act' => obj_to_hash(act).to_json)
        puts "-------success publish to " + user.name + "channel"
      end
      puts "--------publish successful"
      # client.publish('/activity/public', 'acts' => results.to_json)
    }
  end

  #把单个活动数据转换成hash表
  def obj_to_hash(var)
    act_hash = Hash.new
    act_hash[:id] = var.id
    act_hash[:title] = var.title
    act_hash[:time_start] = var.time_start.to_s(:due_time)
    act_hash[:time_end] = var.time_end.to_s(:due_time)
    act_hash[:content] = var.content 
    act_hash[:address] = var.address.address 
    act_hash[:address_line] = var.address.addressLine
    act_hash[:ps] = var.back_up 
    act_hash[:state] = var.state 
    act_hash[:created_at] = var.created_at.to_s(:due_time) 
    act_hash[:creator_id] = var.user_id
    act_hash[:creator_name] = User.find(var.user_id).name
    act_hash[:creator_photo] = User.find(var.user_id).photo.url(:thumb)
    act_hash[:lat] = var.address.lat
    act_hash[:lng] = var.address.lng
    act_hash[:type] = var.tags[0].content
    act_hash
  end

  def test_all
    Activity.all
  end 
end
