class User < ActiveRecord::Base
  attr_accessible :name, :email, :password, :password_confirmation,:photo
  has_attached_file :photo, :styles => { :medium => "300x300>", :thumb => "52x52>" }
  has_secure_password
  has_many :microposts, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :activities, dependent: :destroy
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed
  has_many :reverse_relationships, foreign_key: "followed_id",
                                   class_name:  "Relationship",
                                   dependent:   :destroy
  has_many :followers, through: :reverse_relationships, source: :follower
  
  has_many :user_ac_relas, foreign_key: "user_id", dependent: :destroy
  has_many :followed_acts, through: :user_ac_relas, source: :activity

  before_save { |user| user.email = email.downcase }
  before_save :create_remember_token

  # validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6 }
  # validates :password_confirmation, presence: true

  def feed
    Micropost.from_users_followed_by(self)
  end

  def feed_for_activity
    # Activity.where("user_id = ?", 1)
    Activity.order("created_at")
  end


  def following?(other_user)
    relationships.find_by_followed_id(other_user.id)
  end

  def unfollow!(other_user)
    relationships.find_by_followed_id(other_user.id).destroy
  end

  def following_for_activity?(act)
    user_ac_relas.find_by_activity_id(act)
  end

  def follow_for_activity!(act)
    user_ac_relas.create!(activity_id: act.id)
    act.tags.each do |t|
      add_tag(t)
    end
  end

  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end

  def unfollow_for_activity!(act)
    user_ac_relas.find_by_activity_id(act).destroy
  end

  def has_photo?
    true
  end
  

  private

    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end

    def add_tag(tag)
      InterestTagRecord.create!(user_id: self.id, tag_id: tag.id)
    end
   
    def self.find_test
      sleep 10
      self.find(:all)
    end
end
# == Schema Information
#
# Table name: users
#
#  id                 :integer         not null, primary key
#  name               :string(255)
#  email              :string(255)
#  created_at         :datetime        not null
#  updated_at         :datetime        not null
#  password_digest    :string(255)
#  remember_token     :string(255)
#  admin              :boolean         default(FALSE)
#  photo_file_name    :string(255)
#  photo_content_type :string(255)
#  photo_file_size    :integer
#  photo_updated_at   :datetime
#

