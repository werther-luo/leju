class ActTagRela < ActiveRecord::Base
  attr_accessible :activity_id, :tag_id

  belongs_to :activity, class_name: "Activity"
  belongs_to :tag, class_name: "Tag"

  validates :activity_id, presence: true
  validates :tag_id, presence: true
end
# == Schema Information
#
# Table name: act_tag_relas
#
#  id          :integer         not null, primary key
#  activity_id :integer
#  tag_id      :integer
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#

