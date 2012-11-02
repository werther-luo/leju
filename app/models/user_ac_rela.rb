class UserAcRela < ActiveRecord::Base
  attr_accessible :activity_id, :user_id

  belongs_to :user, class_name: "User"
  belongs_to :activity, class_name: "Activity"

  validates :user_id, presence: true
  validates :activity_id, presence: true
end
# == Schema Information
#
# Table name: user_ac_relas
#
#  id          :integer         not null, primary key
#  user_id     :integer
#  activity_id :integer
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#

