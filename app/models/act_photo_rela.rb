class ActPhotoRela < ActiveRecord::Base
  attr_accessible :activity_id, :photo_id

  belongs_to :activity, class_name: "Activity"
  belongs_to :photo, class_name: "Photo"

  validates :activity_id, presence: true
  validates :photo_id, presence: true
end
# == Schema Information
#
# Table name: act_photo_relas
#
#  id          :integer         not null, primary key
#  activity_id :integer
#  photo_id    :integer
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#

