class StaticPagesController < ApplicationController
  require 'net/http'
  def home
    if signed_in?
      @micropost  = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page])
    end
  end
  
  def help
  end

  def about
    
  end

  def contact
  end

  def show_activity
    if signed_in?
      @tags = Tag.get_tags
      @activity  = current_user.activities.build
      # @feed_items = current_user.feed_for_activity.paginate(page: params[:page])
      @activities = current_user.feed_for_activity.paginate(page: params[:page])
    end
  end

  def map
    @activity = current_user.activities.build
  end

  def jiepan
    

    url = URI.parse('http://api.jiepang.com/v1/locations/search?lat=39.916&lon=116.393&count=2&source=100639')
    req = Net::HTTP::Get.new(url.path)
    res = Net::HTTP.start(url.host, url.port) {|http|
    http.request(req)
    }
    puts res.body
    
  end
end
