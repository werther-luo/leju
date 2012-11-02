class AddPcountToActivities < ActiveRecord::Migration
  def change
    add_column :activities, :pcount, :intger
  end
end
