class InterestTagRecord < ActiveRecord::Base
  attr_accessible :tag_id, :user_id

  def self.get_hotest_tags(user, tags_count)
  	# self.select("*").group("tag_id", "user_id").
  	# 				 having("user_id==?",user.id).
  	# 				 order("tag_id".count).limit(tags_count)
  	self.find(:all, 
  		select: "user_id,tag_id,count(tag_id) as tags_count", 
  		group: "tag_id, user_id",
  		having: ["user_id=?", user.id],
  		order: "tags_count DESC",
  		limit: 3)
  end
end
# select user_id, tag_id, count(tag_id) from interest_tag_records group by tag_id,user_id having user_id = 1 order by count(tag_id) desc limit 3# == Schema Information
#
# Table name: interest_tag_records
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  tag_id     :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

