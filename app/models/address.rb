class Address < ActiveRecord::Base
  attr_accessible :address, :addressLine, :lat, :lng, :activity_id

  belongs_to :activity

  def self.getAround(lat,lng)
  	# neighborActivitiesId = "select activity_id from address"
  	# Client.where("orders_count = ? AND locked = ?", params[:orders], false)
  	Address.select(:activity_id).where("lat > ? AND lat < ? AND lng > ? AND lng < ?",lat-0.01,lat+0.01,lng-0.01,lng+0.01)
  	# AND (lng => (lng-1..lng+1))
  	# Client.all(:conditions => ["created_at IN (?)", (params[:start_date].to_date)..(params[:end_date].to_date])  
  end
end
