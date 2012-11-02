class AddActivityIdToMicropost < ActiveRecord::Migration
  def change
    add_column :microposts, :activity_id, :integer
  end
end
