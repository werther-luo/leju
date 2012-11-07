class MessageController < ApplicationController
  require 'net/http'
  require "json"
	before_filter :signed_in_user
	respond_to :html, :js, :json

  puts "--------init controller"
  
  def index
    puts "--------enter index method"
    @activity_id = params[:activity_id]
    puts "--------geted activity_id:" + @activity_id.to_s
    @messages = Message.find_by_activity_id(@activity_id)
    
    #服务器不再监听，也不再广播，只是进行基本的数据存储
    #开始监听这个活动
    # EM.run {
    #       client = Faye::Client.new('http://localhost:9292/faye')
    # 
    #       client.subscribe("/act_msg/#{@activity_id}") do |message|
    #         puts message.inspect
    #         
    #       end
    #       
    #       # client.publish('/messages/public', 'msg' => 'Hello world')
    #     }
    
    respond_to do |format|
      format.json { render :json => @messages}
    end
  end

  def new
    puts "---------enter new method"
    @activity_id = 5 #params[:activity_id]
    @user_id = 1 #params[:user_id]
    @msg_content = "test content" #params[:content]
    @msg = Activity.find(@activity_id).messages.build()
    @msg.user_id = @user_id
    @msg.content = @msg_content
    if @msg.save
      puts "--------success save message"
    else
      puts "--------fail to save message"
    end
  end
  
  def create
    puts "---------enter create method"
    @activity_id = params[:activity_id]
    puts "---------geted activity_id" + @activity_id.to_s
    @user_id = current_user.id
    @msg_content = params[:message]
    @activity = Activity.find(@activity_id)
    @msg = @activity.messages.build()
    @msg.user_id = @user_id
    @msg.content = @msg_content
    if @msg.save
      puts "--------success save message"
    else
      puts "--------fail to save message"
    end

    respond_to do |format|
      format.json { render :json => @msg}
    end
  end
  
end
