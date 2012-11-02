class Photo < ActiveRecord::Base
  attr_accessible :description, :title, :user_id, :image

  has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>" }

  # has_many :reverse_act_photo_relas, foreign_key: "photo_id",
  # 									 class_name:  "ActPhotoRela",
  # 									 dependent: :destroy	
  # belongs_to :activity
  def has_image?
  	# self.image.file?
    true
  end
  # validates :user_id, presence: true
end
# == Schema Information
#
# Table name: photos
#
#  id                 :integer         not null, primary key
#  user_id            :integer
#  title              :string(255)
#  description        :string(255)
#  created_at         :datetime        not null
#  updated_at         :datetime        not null
#  image_file_name    :string(255)
#  image_content_type :string(255)
#  image_file_size    :integer
#  image_updated_at   :datetime
#  activity_id        :integer
#

