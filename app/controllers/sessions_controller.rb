class SessionsController < ApplicationController

  def new
  end

  def create
    @lat = 25.1 #用户登陆的经纬度，应该有传过来的参数设置
    @lng = 101.1
    puts "-------geted user name:" + params[:session][:email]
    puts "-------geted password:" + params[:session][:password]
    user = User.find_by_email(params[:session][:email])
    if user && user.authenticate(params[:session][:password])
      sign_in user
      # 登陆位置的经纬度加入signedAddress表中
      set_signed_address(@lat, @lng, user.id)
      # redirect_back_or user
      puts "------singin success,start redirect"
      redirect_to map_path
    else
      flash.now[:error] = 'Invalid email/password combination'
      redirect_to map_path
    end
  end

  def destroy
    sign_out
    redirect_to login_path
  end

  def set_signed_address(lat, lng, user_id)
    if SignedAddress.create(lat:lat, lng:lng, user_id:user_id, state:0)
      puts "--------sined address success"
    end
  end
end