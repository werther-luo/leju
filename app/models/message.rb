class Message < ActiveRecord::Base
  attr_accessible :activity_id, :content, :user_id
  belongs_to :user
  belongs_to :activity

  default_scope order: 'messages.created_at DESC'

end
