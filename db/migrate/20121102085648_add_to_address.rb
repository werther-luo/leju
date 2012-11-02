class AddToAddress < ActiveRecord::Migration
  def change
    add_column :addresses, :activity_id, :intger
  end
end
