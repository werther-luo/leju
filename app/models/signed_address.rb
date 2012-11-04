class SignedAddress < ActiveRecord::Base
  attr_accessible :lat, :lng, :state, :user_id

  def self.get_near_by(lat, lng, rang)
  	@user_ids = "SELECT user_id FROM signed_addresses where 
              lat>#{lat-rang} AND lat<#{lat+rang} 
              AND lng>#{lng-rang} AND lng<#{lng+rang}"
    User.where("id IN (#{@user_ids})")
  end
end
