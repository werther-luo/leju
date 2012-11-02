require 'spec_helper'

describe Activity do
  pending "add some examples to (or delete) #{__FILE__}"
end
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

