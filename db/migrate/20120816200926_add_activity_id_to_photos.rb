class AddActivityIdToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :activity_id, :integer
  end
end
