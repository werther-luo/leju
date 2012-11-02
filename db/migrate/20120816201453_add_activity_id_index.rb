class AddActivityIdIndex < ActiveRecord::Migration
  def up
  	add_index :photos, :activity_id
  end

  def down
  end
end
