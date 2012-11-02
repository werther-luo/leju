class Address < ActiveRecord::Base
  attr_accessible :address, :addressLine, :lat, :lng, :activity_id

  belongs_to :activity
end
