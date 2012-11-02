require 'spec_helper'

describe Photo do
  pending "add some examples to (or delete) #{__FILE__}"
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

