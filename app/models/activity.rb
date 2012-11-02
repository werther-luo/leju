# == Schema Information
#
# Table name: activities
#
#  id              :integer         not null, primary key
#  title           :string(255)
#  time_start      :datetime
#  time_end        :datetime
#  content         :string(255)
#  GUID            :string(255)
#  GUID_created_at :string(255)
#  back_up         :string(255)
#  state           :integer         default(0), not null
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#  user_id         :integer
#

class Activity < ActiveRecord::Base
  attr_accessible :GUID, :GUID_created_at, :back_up, :content, :state, :time_end, :time_start, :title


  belongs_to :user
  has_many :microposts, dependent: :destroy
  # has_many :users
  has_many :reverse_user_ac_relas, 	foreign_key: "activity_id",
  									class_name:  "UserAcRela",
  									dependent: :destroy	
  has_many :act_followers, through: :reverse_user_ac_relas, source: :user

  has_many :act_tag_relas, foreign_key: "activity_id", dependent: :destroy
  has_many :tags, through: :act_tag_relas, source: :tag 
  has_many :photos, dependent: :destroy
  # has_many :act_photo_relas, foreign_key: "activity_id", dependent: :destroy
  # has_many :photos, through: :act_photo_relas, source: :photo

  validates :user_id, 	presence: true
  validates :title, 	presence: true
  validates :GUID, 		presence: true

  default_scope :order => 'activities.created_at DESC'

  def creator
    User.find_by_id(user_id)
  end

  def taging?(tag)
    act_tag_relas.find_by_tag_id(tag)
  end

  def tag!(tag)
  act_tag_relas.create!(tag_id: tag.id)    
  end

  def untag!(tag)
    act_tag_relas.find_by_tag_id(tag).destroy
  end
  
end

