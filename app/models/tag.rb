class Tag < ActiveRecord::Base
  attr_accessible :content
  has_many :reverse_act_tag_relas, 	foreign_key: "tag_id",
  									class_name:  "ActTagRela",
  									dependent: :destroy	
  has_many :taged_activities, through: :reverse_act_tag_relas, source: :activity

  validates :content, presence: true

  def self.get_tags
  	Tag.order("created_at")
  end

  
end
# == Schema Information
#
# Table name: tags
#
#  id         :integer         not null, primary key
#  content    :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

